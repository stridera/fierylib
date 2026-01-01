"""
Shop Importer - Imports shop data from legacy .shp files to PostgreSQL

Handles:
- Shops with composite primary keys (zoneId, vnum)
- Shop items (selling inventory)
- Shop accepts (item types they buy)
- Shop rooms (locations where shop operates)
- Shop hours (opening/closing times)
"""

from typing import Optional
from pathlib import Path
import sys

from mud.types.shop import Shop
from mud.mudfile import MudData
from mud.bitflags import BitFlags
from fierylib.converters import EntityResolver


class ShopImporter:
    """Imports shop data to PostgreSQL using Prisma"""

    def __init__(self, prisma_client):
        """
        Initialize shop importer

        Args:
            prisma_client: Prisma client instance
        """
        self.prisma = prisma_client
        self.resolver = EntityResolver(prisma_client)

    async def import_shop(self, shop: Shop, zone_id: int, dry_run: bool = False) -> dict:
        """
        Import a single shop to the database

        Args:
            shop: Parsed Shop object from Shop.parse()
            zone_id: Zone ID (already converted, e.g., 30 or 1000)
            dry_run: If True, validate but don't write to database

        Returns:
            Dict with import results

        Examples:
            >>> shop = Shop(id=3010, keeper=3010, ...)
            >>> result = await importer.import_shop(shop, 30)
            >>> print(result["vnum"])
            10
        """
        # Parse shop ID to get vnum (use zone_id parameter)
        # Zone boundaries in CircleMUD are flexible - shop 3150 in zone 30
        # should be stored as (30, 150), not (31, 50).
        shop_id = int(shop.id)
        vnum = shop_id - (zone_id * 100)  # Relative to zone base

        # Resolve keeper mob using EntityResolver
        keeper_zone_id = None
        keeper_id = None
        keeper_exists = False
        if shop.keeper:
            keeper_result = await self.resolver.resolve_mob(
                int(shop.keeper), context_zone=zone_id
            )
            if keeper_result:
                keeper_zone_id = keeper_result.zone_id
                keeper_id = keeper_result.id
                keeper_exists = True

        # Build message arrays from legacy fields
        no_such_item_messages = []
        if hasattr(shop, 'no_such_item1') and shop.no_such_item1:
            no_such_item_messages.append(shop.no_such_item1)
        if hasattr(shop, 'no_such_item2') and shop.no_such_item2:
            no_such_item_messages.append(shop.no_such_item2)

        do_not_buy_messages = []
        if hasattr(shop, 'do_not_buy') and shop.do_not_buy:
            do_not_buy_messages.append(shop.do_not_buy)

        missing_cash_messages = []
        if hasattr(shop, 'missing_cash1') and shop.missing_cash1:
            missing_cash_messages.append(shop.missing_cash1)
        if hasattr(shop, 'missing_cash2') and shop.missing_cash2:
            missing_cash_messages.append(shop.missing_cash2)

        buy_messages = []
        if hasattr(shop, 'message_buy') and shop.message_buy:
            buy_messages.append(shop.message_buy)

        sell_messages = []
        if hasattr(shop, 'message_sell') and shop.message_sell:
            sell_messages.append(shop.message_sell)

        if dry_run:
            return {
                "success": True,
                "zone_id": zone_id,
                "vnum": vnum,
                "action": "validated",
            }

        try:
            # Build create/update data
            create_data = {
                "id": vnum,
                "zoneId": zone_id,
                "buyProfit": float(shop.buy_profit) if shop.buy_profit else 1.2,
                "sellProfit": float(shop.sell_profit) if shop.sell_profit else 0.8,
                "temper": int(shop.temper1) if hasattr(shop, 'temper1') and shop.temper1 else 0,
                "noSuchItemMessages": no_such_item_messages,
                "doNotBuyMessages": do_not_buy_messages,
                "missingCashMessages": missing_cash_messages,
                "buyMessages": buy_messages,
                "sellMessages": sell_messages,
            }

            update_data = {
                "buyProfit": float(shop.buy_profit) if shop.buy_profit else 1.2,
                "sellProfit": float(shop.sell_profit) if shop.sell_profit else 0.8,
                "temper": int(shop.temper1) if hasattr(shop, 'temper1') and shop.temper1 else 0,
                "noSuchItemMessages": no_such_item_messages,
                "doNotBuyMessages": do_not_buy_messages,
                "missingCashMessages": missing_cash_messages,
                "buyMessages": buy_messages,
                "sellMessages": sell_messages,
            }

            # Only set keeper fields if keeper mob exists in database
            if keeper_exists:
                create_data["keeperZoneId"] = keeper_zone_id
                create_data["keeperId"] = keeper_id
                update_data["keeperZoneId"] = keeper_zone_id
                update_data["keeperId"] = keeper_id

            # Upsert shop with composite key
            shop_record = await self.prisma.shops.upsert(
                where={
                    "zoneId_id": {
                        "zoneId": zone_id,
                        "id": vnum,
                    }
                },
                data={
                    "create": create_data,
                    "update": update_data,
                },
            )

            # Add SHOPKEEPER flag to the keeper mob
            if keeper_exists:
                try:
                    # Get current mob flags
                    keeper_mob = await self.prisma.mobs.find_unique(
                        where={
                            "zoneId_id": {
                                "zoneId": keeper_zone_id,
                                "id": keeper_id,
                            }
                        }
                    )
                    if keeper_mob and "SHOPKEEPER" not in keeper_mob.mobFlags:
                        new_flags = list(keeper_mob.mobFlags) + ["SHOPKEEPER"]
                        await self.prisma.mobs.update(
                            where={
                                "zoneId_id": {
                                    "zoneId": keeper_zone_id,
                                    "id": keeper_id,
                                }
                            },
                            data={"mobFlags": new_flags}
                        )
                except Exception as e:
                    # Non-fatal - just log the warning
                    pass

            # Import shop items (selling inventory)
            items_imported = 0
            if shop.selling:
                for item_vnum, quantity in shop.selling.items():
                    item_result = await self.import_shop_item(
                        zone_id, vnum, item_vnum, quantity
                    )
                    if item_result["success"]:
                        items_imported += 1

            # Import shop accepts (item types they buy)
            accepts_imported = 0
            if shop.accepts:
                for accept in shop.accepts:
                    accept_result = await self.import_shop_accept(
                        zone_id, vnum, accept
                    )
                    if accept_result["success"]:
                        accepts_imported += 1

            # Import shop rooms
            rooms_imported = 0
            if shop.rooms:
                for room_vnum in shop.rooms:
                    room_result = await self.import_shop_room(
                        zone_id, vnum, room_vnum
                    )
                    if room_result["success"]:
                        rooms_imported += 1

            # Import shop hours
            hours_imported = 0
            if shop.hours:
                for hour_data in shop.hours:
                    hour_result = await self.import_shop_hour(
                        zone_id, vnum, hour_data
                    )
                    if hour_result["success"]:
                        hours_imported += 1

            result = {
                "success": True,
                "zone_id": zone_id,
                "vnum": vnum,
                "action": "imported",
                "items": items_imported,
                "accepts": accepts_imported,
                "rooms": rooms_imported,
                "hours": hours_imported,
            }

            # Add warning if keeper mob doesn't exist
            if shop.keeper and not keeper_exists:
                result["warning"] = f"Keeper mob {shop.keeper} ({keeper_zone_id}:{keeper_id}) not found"

            return result

        except Exception as e:
            return {
                "success": False,
                "zone_id": zone_id,
                "vnum": vnum,
                "action": "failed",
                "error": str(e),
            }

    def _normalize_stock_amount(self, legacy_amount: int) -> int:
        """
        Convert legacy CircleMUD stock amount to modern convention.

        Legacy convention:
            0 = unlimited stock
            1-99 = limited stock (that quantity)
            >= 100 = corrupted data (treat as qty 1)

        Modern convention:
            -1 = unlimited stock
            1+ = limited stock
        """
        MAX_VALID_STOCK = 99
        if legacy_amount == 0:
            return -1  # Unlimited
        elif legacy_amount > MAX_VALID_STOCK:
            return 1  # Corrupted data -> single item
        else:
            return legacy_amount

    async def import_shop_item(
        self, shop_zone_id: int, shop_vnum: int, item_vnum: int, quantity: int
    ) -> dict:
        """
        Import a shop item (selling inventory)

        Args:
            shop_zone_id: Shop's zone ID
            shop_vnum: Shop's vnum
            item_vnum: Legacy item vnum being sold (e.g., 3109)
            quantity: Legacy quantity (0 = unlimited, 1-99 = limited, >= 100 = corrupted)

        Returns:
            Dict with import results
        """
        try:
            # Use EntityResolver to find the object
            result = await self.resolver.resolve_object(
                int(item_vnum), context_zone=shop_zone_id
            )

            if not result:
                return {
                    "success": False,
                    "item_vnum": item_vnum,
                    "error": f"Object {item_vnum} not found in database",
                }

            # Convert legacy amount to modern convention
            normalized_amount = self._normalize_stock_amount(quantity)

            await self.prisma.shopitems.create(
                data={
                    "shopZoneId": shop_zone_id,
                    "shopId": shop_vnum,
                    "objectZoneId": result.zone_id,
                    "objectId": result.id,
                    "amount": normalized_amount,
                }
            )

            return {
                "success": True,
                "item_vnum": item_vnum,
                "resolved": f"{result.zone_id}:{result.id}",
            }

        except Exception as e:
            return {
                "success": False,
                "item_vnum": item_vnum,
                "error": str(e),
            }

    async def import_shop_accept(
        self, shop_zone_id: int, shop_vnum: int, accept: dict
    ) -> dict:
        """
        Import shop accept (item types they buy)

        Args:
            shop_zone_id: Shop's zone ID
            shop_vnum: Shop's vnum
            accept: Dict with type and keywords

        Returns:
            Dict with import results
        """
        try:
            keywords_str = accept.get("keywords", "")
            keywords_list = keywords_str.split() if keywords_str else []
            
            await self.prisma.shopaccepts.create(
                data={
                    "shopZoneId": shop_zone_id,
                    "shopId": shop_vnum,
                    "type": accept.get("type", ""),
                    "keywords": keywords_list,
                }
            )

            return {"success": True}

        except Exception as e:
            return {
                "success": False,
                "error": str(e),
            }

    async def import_shop_room(
        self, shop_zone_id: int, shop_vnum: int, room_vnum: int
    ) -> dict:
        """
        Import shop room (location where shop operates)

        Args:
            shop_zone_id: Shop's zone ID
            shop_vnum: Shop's vnum
            room_vnum: Room vnum where shop operates (legacy ID, not composite)

        Returns:
            Dict with import results
        """
        try:
            await self.prisma.shoprooms.create(
                data={
                    "shopZoneId": shop_zone_id,
                    "shopId": shop_vnum,
                    "roomId": int(room_vnum),
                }
            )

            return {"success": True, "room_vnum": room_vnum}

        except Exception as e:
            return {
                "success": False,
                "room_vnum": room_vnum,
                "error": str(e),
            }

    async def import_shop_hour(
        self, shop_zone_id: int, shop_vnum: int, hour_data: dict
    ) -> dict:
        """
        Import shop hour (opening/closing times)

        Args:
            shop_zone_id: Shop's zone ID
            shop_vnum: Shop's vnum
            hour_data: Dict with open and close times

        Returns:
            Dict with import results
        """
        try:
            await self.prisma.shophours.create(
                data={
                    "shopZoneId": shop_zone_id,
                    "shopId": shop_vnum,
                    "open": hour_data.get("open", 0),
                    "close": hour_data.get("close", 0),
                }
            )

            return {"success": True}

        except Exception as e:
            return {
                "success": False,
                "error": str(e),
            }

    async def import_shop_mob(
        self, shop_zone_id: int, shop_id: int, mob_zone_id: int, mob_id: int,
        amount: int = 0
    ) -> dict:
        """
        Import a shop mob (pet/mount for sale)

        Args:
            shop_zone_id: Shop's zone ID
            shop_id: Shop's vnum
            mob_zone_id: Mob's zone ID
            mob_id: Mob's vnum
            amount: Legacy quantity (0 = unlimited, 1-99 = limited, >= 100 = corrupted)

        Returns:
            Dict with import results
        """
        try:
            # Convert legacy amount to modern convention
            normalized_amount = self._normalize_stock_amount(amount)

            await self.prisma.shopmobs.create(
                data={
                    "shopZoneId": shop_zone_id,
                    "shopId": shop_id,
                    "mobZoneId": mob_zone_id,
                    "mobId": mob_id,
                    "amount": normalized_amount,
                }
            )

            return {"success": True, "mob": f"{mob_zone_id}:{mob_id}"}

        except Exception as e:
            return {
                "success": False,
                "mob": f"{mob_zone_id}:{mob_id}",
                "error": str(e),
            }

    async def _set_sells_mobs_flag(self, shop_zone_id: int, shop_id: int) -> bool:
        """
        Add SELLS_MOBS flag to a shop if not already set.

        Args:
            shop_zone_id: Shop's zone ID
            shop_id: Shop's vnum

        Returns:
            True if flag was set or already present, False on error
        """
        try:
            shop = await self.prisma.shops.find_unique(
                where={
                    "zoneId_id": {
                        "zoneId": shop_zone_id,
                        "id": shop_id,
                    }
                }
            )
            if shop and "SELLS_MOBS" not in shop.flags:
                new_flags = list(shop.flags) + ["SELLS_MOBS"]
                await self.prisma.shops.update(
                    where={
                        "zoneId_id": {
                            "zoneId": shop_zone_id,
                            "id": shop_id,
                        }
                    },
                    data={"flags": new_flags}
                )
            return True
        except Exception:
            return False

    async def detect_and_import_pet_shop_mobs(
        self, zone_id: int, dry_run: bool = False
    ) -> dict:
        """
        DEPRECATED: This function uses aggressive backroom detection that
        incorrectly links guards and other NPCs to shops.

        Use import_pet_shop_from_legacy_spec() instead, which takes explicit
        room VNUMs from the legacy spec_assign.cpp data.

        Legacy behavior attempted:
        1. For each shop, get its operating rooms
        2. Check if mobs spawn in room_vnum + 1 (the backroom pattern)
        3. Link those mobs to the shop via ShopMobs

        Problem: Many shops have guards/NPCs in adjacent rooms that are NOT
        pets for sale. Only rooms with the pet_shop spec_proc should be treated
        as pet shops.

        Args:
            zone_id: Zone ID to process
            dry_run: If True, validate but don't write to database

        Returns:
            Dict with results (may contain false positives!)
        """
        results = {
            "success": True,
            "pet_shops_found": 0,
            "mobs_linked": 0,
            "backrooms_detected": [],
            "details": [],
        }

        try:
            # Get all shops in this zone with their rooms
            shops = await self.prisma.shops.find_many(
                where={"zoneId": zone_id},
                include={"shopRooms": True}
            )

            # Get all mob resets in this zone
            mob_resets = await self.prisma.mobresets.find_many(
                where={"zoneId": zone_id}
            )

            # Build a map of room_vnum -> list of (mob_zone_id, mob_id)
            # The room_vnum is calculated from the composite key
            room_to_mobs = {}
            for reset in mob_resets:
                # Calculate legacy room vnum from composite key
                room_vnum = (reset.roomZoneId * 100) + reset.roomId
                if reset.roomZoneId == 1000:
                    room_vnum = reset.roomId  # Zone 0 special case

                if room_vnum not in room_to_mobs:
                    room_to_mobs[room_vnum] = []
                room_to_mobs[room_vnum].append((reset.mobZoneId, reset.mobId))

            # Check each shop for backroom pattern
            for shop in shops:
                for shop_room in shop.shopRooms:
                    shop_room_vnum = shop_room.roomId  # This is the legacy vnum
                    backroom_vnum = shop_room_vnum + 1

                    # Check if mobs spawn in the backroom
                    if backroom_vnum in room_to_mobs:
                        mobs_in_backroom = room_to_mobs[backroom_vnum]

                        if mobs_in_backroom:
                            results["pet_shops_found"] += 1
                            results["backrooms_detected"].append({
                                "shop": f"{shop.zoneId}:{shop.id}",
                                "shop_room": shop_room_vnum,
                                "backroom": backroom_vnum,
                                "mobs_found": len(mobs_in_backroom),
                            })

                            # Link each mob to the shop
                            for mob_zone_id, mob_id in mobs_in_backroom:
                                if dry_run:
                                    results["mobs_linked"] += 1
                                    results["details"].append({
                                        "action": "would_link",
                                        "shop": f"{shop.zoneId}:{shop.id}",
                                        "mob": f"{mob_zone_id}:{mob_id}",
                                    })
                                else:
                                    link_result = await self.import_shop_mob(
                                        shop.zoneId, shop.id,
                                        mob_zone_id, mob_id
                                    )
                                    if link_result["success"]:
                                        results["mobs_linked"] += 1
                                        results["details"].append({
                                            "action": "linked",
                                            "shop": f"{shop.zoneId}:{shop.id}",
                                            "mob": f"{mob_zone_id}:{mob_id}",
                                        })
                                    else:
                                        results["details"].append({
                                            "action": "failed",
                                            "shop": f"{shop.zoneId}:{shop.id}",
                                            "mob": f"{mob_zone_id}:{mob_id}",
                                            "error": link_result.get("error"),
                                        })

                            # Set SELLS_MOBS flag on the shop
                            if not dry_run and results["mobs_linked"] > 0:
                                await self._set_sells_mobs_flag(shop.zoneId, shop.id)

            return results

        except Exception as e:
            return {
                "success": False,
                "error": str(e),
                "pet_shops_found": 0,
                "mobs_linked": 0,
            }

    async def import_shops_from_file(
        self, shp_file_path: Path, zone_id: int, dry_run: bool = False
    ) -> dict:
        """
        Import shops from a legacy .shp file

        Args:
            shp_file_path: Path to .shp file
            zone_id: Zone ID from filename (e.g., 30 from "30.shp") - REQUIRED
            dry_run: If True, validate but don't write to database

        Returns:
            Dict with import results including zones_in_file list

        Examples:
            >>> result = await importer.import_shops_from_file(Path("lib/world/shp/30.shp"), 30)
            >>> print(f"Imported {result['imported']} shops")
        """
        try:
            # Read file
            with open(shp_file_path, "r") as f:
                content = f.read()

            # Parse shops
            lines = content.split("\n")
            mud_data = MudData(lines)
            shops = Shop.parse(mud_data)

            # Handle case where no shops are found
            if not shops:
                return {
                    "success": True,
                    "file": str(shp_file_path),
                    "zones_in_file": [zone_id],
                    "total": 0,
                    "imported": 0,
                    "failed": 0,
                    "shops": [],
                }

            # Use zone_id from filename for ALL shops (supports unlimited shops per zone)
            zones_in_file = {zone_id}

            results = {
                "success": True,
                "file": str(shp_file_path),
                "zones_in_file": sorted(zones_in_file),
                "total": len(shops),
                "imported": 0,
                "failed": 0,
                "shops": [],
            }

            for shop in shops:
                # Always use zone_id from filename (supports unlimited shops per zone)
                result = await self.import_shop(shop, zone_id, dry_run=dry_run)
                results["shops"].append(result)

                if result["success"]:
                    results["imported"] += 1
                else:
                    results["failed"] += 1
                    results["success"] = False

            return results

        except FileNotFoundError:
            return {
                "success": False,
                "file": str(shp_file_path),
                "zone_id": zone_id,
                "error": f"File not found: {shp_file_path}",
            }
        except Exception as e:
            return {
                "success": False,
                "file": str(shp_file_path),
                "zone_id": zone_id,
                "error": f"Parse error: {str(e)}",
            }

    async def import_pet_shop_from_legacy_spec(
        self, room_vnum: int, dry_run: bool = False
    ) -> dict:
        """
        Import a pet shop based on legacy spec_assign.cpp room assignment.

        In legacy CircleMUD, pet shops are ROOMS with the pet_shop spec_proc.
        The spec_proc would show mobs from room_vnum + 1 (the backroom).

        This function:
        1. Finds the shop that operates in this room
        2. Finds mobs that spawn in room_vnum + 1 (backroom)
        3. Links those mobs to the shop via ShopMobs
        4. Sets the SELLS_MOBS flag on the shop

        Known legacy pet shop rooms:
        - 3030: Kayla's Pet Shop (Mielikki)
        - 3091: Jorhan's Mount Shop (Mielikki)
        - 6228: (Zone 62)
        - 10056: (Zone 100)
        - 30012: (Zone 300)
        - 30031: (Zone 300)

        Args:
            room_vnum: Legacy room vnum with pet_shop spec_proc
            dry_run: If True, validate but don't write to database

        Returns:
            Dict with import results
        """
        results = {
            "success": True,
            "room_vnum": room_vnum,
            "shop_found": False,
            "mobs_linked": 0,
            "details": [],
        }

        try:
            # Find shop that operates in this room
            shop_room = await self.prisma.shoprooms.find_first(
                where={"roomId": room_vnum},
                include={"shop": True}
            )

            if not shop_room or not shop_room.shop:
                results["success"] = False
                results["error"] = f"No shop operates in room {room_vnum}"
                return results

            shop = shop_room.shop
            results["shop_found"] = True
            results["shop"] = f"{shop.zoneId}:{shop.id}"

            # Find mobs that spawn in the backroom (room_vnum + 1)
            backroom_vnum = room_vnum + 1

            # Use EntityResolver to find the backroom
            backroom = await self.resolver.resolve_room(
                backroom_vnum, context_zone=shop.zoneId
            )

            if not backroom:
                results["details"].append(f"Backroom {backroom_vnum} not found")
                return results

            # Find mob resets in the backroom
            mob_resets = await self.prisma.mobresets.find_many(
                where={
                    "roomZoneId": backroom.zone_id,
                    "roomId": backroom.id,
                }
            )

            if not mob_resets:
                results["details"].append(f"No mobs found in backroom {backroom_vnum}")
                return results

            # Link each mob to the shop
            for reset in mob_resets:
                if dry_run:
                    results["mobs_linked"] += 1
                    results["details"].append({
                        "action": "would_link",
                        "mob": f"{reset.mobZoneId}:{reset.mobId}",
                    })
                else:
                    link_result = await self.import_shop_mob(
                        shop.zoneId, shop.id,
                        reset.mobZoneId, reset.mobId
                    )
                    if link_result["success"]:
                        results["mobs_linked"] += 1
                        results["details"].append({
                            "action": "linked",
                            "mob": f"{reset.mobZoneId}:{reset.mobId}",
                        })
                    else:
                        results["details"].append({
                            "action": "failed",
                            "mob": f"{reset.mobZoneId}:{reset.mobId}",
                            "error": link_result.get("error"),
                        })

            # Set SELLS_MOBS flag on the shop
            if not dry_run and results["mobs_linked"] > 0:
                await self._set_sells_mobs_flag(shop.zoneId, shop.id)

            return results

        except Exception as e:
            return {
                "success": False,
                "room_vnum": room_vnum,
                "error": str(e),
            }
