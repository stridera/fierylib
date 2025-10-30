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
from fierylib.converters import legacy_id_to_composite


class ShopImporter:
    """Imports shop data to PostgreSQL using Prisma"""

    def __init__(self, prisma_client):
        """
        Initialize shop importer

        Args:
            prisma_client: Prisma client instance
        """
        self.prisma = prisma_client

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
        shop_id = int(shop.id)
        vnum = shop_id % 100  # Extract only the vnum part

        # Parse keeper ID to get zone and vnum
        # Only set keeper if the mob exists in database
        keeper_zone_id = None
        keeper_id = None
        keeper_exists = False
        if shop.keeper:
            keeper_full_id = int(shop.keeper)
            keeper_zone_id = keeper_full_id // 100
            keeper_id = keeper_full_id % 100

            # Check if keeper mob exists before setting relation
            try:
                existing_keeper = await self.prisma.mob.find_unique(
                    where={
                        "zoneId_id": {
                            "zoneId": keeper_zone_id,
                            "id": keeper_id,
                        }
                    }
                )
                keeper_exists = existing_keeper is not None
            except:
                keeper_exists = False

        # Build messages JSON from shop messages
        messages = {}
        if hasattr(shop, 'no_such_item1') and shop.no_such_item1:
            messages['noSuchItem1'] = shop.no_such_item1
        if hasattr(shop, 'no_such_item2') and shop.no_such_item2:
            messages['noSuchItem2'] = shop.no_such_item2
        if hasattr(shop, 'do_not_buy') and shop.do_not_buy:
            messages['doNotBuy'] = shop.do_not_buy
        if hasattr(shop, 'missing_cash1') and shop.missing_cash1:
            messages['missingCash1'] = shop.missing_cash1
        if hasattr(shop, 'missing_cash2') and shop.missing_cash2:
            messages['missingCash2'] = shop.missing_cash2
        if hasattr(shop, 'message_buy') and shop.message_buy:
            messages['messageBuy'] = shop.message_buy
        if hasattr(shop, 'message_sell') and shop.message_sell:
            messages['messageSell'] = shop.message_sell

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
                "temper1": int(shop.temper1) if hasattr(shop, 'temper1') and shop.temper1 else 0,
                "noSuchItem1": shop.no_such_item1 if hasattr(shop, 'no_such_item1') else None,
                "noSuchItem2": shop.no_such_item2 if hasattr(shop, 'no_such_item2') else None,
                "doNotBuy": shop.do_not_buy if hasattr(shop, 'do_not_buy') else None,
                "missingCash1": shop.missing_cash1 if hasattr(shop, 'missing_cash1') else None,
                "missingCash2": shop.missing_cash2 if hasattr(shop, 'missing_cash2') else None,
                "messageBuy": shop.message_buy if hasattr(shop, 'message_buy') else None,
                "messageSell": shop.message_sell if hasattr(shop, 'message_sell') else None,
            }

            update_data = {
                "buyProfit": float(shop.buy_profit) if shop.buy_profit else 1.2,
                "sellProfit": float(shop.sell_profit) if shop.sell_profit else 0.8,
                "temper1": int(shop.temper1) if hasattr(shop, 'temper1') and shop.temper1 else 0,
                "noSuchItem1": shop.no_such_item1 if hasattr(shop, 'no_such_item1') else None,
                "noSuchItem2": shop.no_such_item2 if hasattr(shop, 'no_such_item2') else None,
                "doNotBuy": shop.do_not_buy if hasattr(shop, 'do_not_buy') else None,
                "missingCash1": shop.missing_cash1 if hasattr(shop, 'missing_cash1') else None,
                "missingCash2": shop.missing_cash2 if hasattr(shop, 'missing_cash2') else None,
                "messageBuy": shop.message_buy if hasattr(shop, 'message_buy') else None,
                "messageSell": shop.message_sell if hasattr(shop, 'message_sell') else None,
            }

            # Only set keeper fields if keeper mob exists in database
            if keeper_exists:
                create_data["keeperZoneId"] = keeper_zone_id
                create_data["keeperId"] = keeper_id
                update_data["keeperZoneId"] = keeper_zone_id
                update_data["keeperId"] = keeper_id

            # Upsert shop with composite key
            shop_record = await self.prisma.shop.upsert(
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

    async def import_shop_item(
        self, shop_zone_id: int, shop_vnum: int, item_vnum: int, quantity: int
    ) -> dict:
        """
        Import a shop item (selling inventory)

        Args:
            shop_zone_id: Shop's zone ID
            shop_vnum: Shop's vnum
            item_vnum: Item vnum being sold
            quantity: Quantity in stock (0 = unlimited)

        Returns:
            Dict with import results
        """
        try:
            # Parse item ID to get zone and vnum
            item_id = int(item_vnum)
            object_zone_id = item_id // 100
            object_vnum = item_id % 100

            await self.prisma.shopitem.create(
                data={
                    "shopZoneId": shop_zone_id,
                    "shopVnum": shop_vnum,
                    "objectZoneId": object_zone_id,
                    "objectVnum": object_vnum,
                    "amount": quantity,
                }
            )

            return {"success": True, "item_vnum": item_vnum}

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
            
            await self.prisma.shopaccept.create(
                data={
                    "shopZoneId": shop_zone_id,
                    "shopVnum": shop_vnum,
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
            await self.prisma.shoproom.create(
                data={
                    "shopZoneId": shop_zone_id,
                    "shopVnum": shop_vnum,
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
            await self.prisma.shophour.create(
                data={
                    "shopZoneId": shop_zone_id,
                    "shopVnum": shop_vnum,
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
