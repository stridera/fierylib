"""
Lua API Loader - loads and validates against the shared lua_api.yaml definition.

This module provides access to the machine-readable API definition for use in
the DG-to-Lua converter and for validation purposes.
"""

from pathlib import Path
from typing import Optional

import yaml
from pydantic import BaseModel


class ParamDef(BaseModel):
    """Definition of a function parameter."""

    name: str
    type: str
    optional: bool = False


class FunctionDef(BaseModel):
    """Definition of a Lua API function."""

    description: str = ""
    params: list[ParamDef] = []
    returns: str | list[str] | None = None
    status: str = "not_implemented"

    def is_implemented(self) -> bool:
        return self.status == "implemented"


class NamespaceDef(BaseModel):
    """Definition of a Lua namespace (table of functions)."""

    description: str = ""
    functions: dict[str, FunctionDef] = {}


class PropertyDef(BaseModel):
    """Definition of a read-only property."""

    type: str
    status: str = "not_implemented"

    def is_implemented(self) -> bool:
        return self.status == "implemented"


class LuaApi(BaseModel):
    """The complete Lua API definition."""

    version: str = "1.0"
    types: dict[str, str] = {}
    error_codes: list[str] = []
    namespaces: dict[str, NamespaceDef] = {}
    globals: dict[str, FunctionDef] = {}
    actor: dict[str, FunctionDef] = {}
    actor_properties: dict[str, PropertyDef] = {}
    actor_inventory: dict[str, FunctionDef] = {}
    room: dict[str, FunctionDef] = {}
    room_properties: dict[str, PropertyDef] = {}
    object: dict[str, FunctionDef] = {}
    object_properties: dict[str, PropertyDef] = {}
    quest: dict[str, FunctionDef] = {}
    enums: dict[str, list[str]] = {}


class LuaApiLoader:
    """
    Loads and provides access to the Lua API definition.

    Usage:
        loader = LuaApiLoader()
        api = loader.load()

        # Check if a namespace function exists
        if loader.has_function("combat", "engage"):
            ...

        # Get function definition
        func = loader.get_function("combat", "engage")
    """

    _instance: Optional["LuaApiLoader"] = None
    _api: Optional[LuaApi] = None

    def __new__(cls) -> "LuaApiLoader":
        """Singleton pattern."""
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    @classmethod
    def get_api_path(cls) -> Path:
        """Get the path to the lua_api.yaml file."""
        # Look for it relative to this file
        this_file = Path(__file__)
        # fierylib/src/fierylib/converters/lua_api_loader.py
        # -> shared/lua_api.yaml (at repo root)
        repo_root = this_file.parent.parent.parent.parent.parent
        api_path = repo_root / "shared" / "lua_api.yaml"

        if not api_path.exists():
            # Try alternate location
            alt_path = Path.cwd() / "shared" / "lua_api.yaml"
            if alt_path.exists():
                return alt_path
            raise FileNotFoundError(
                f"Could not find lua_api.yaml at {api_path} or {alt_path}"
            )

        return api_path

    def load(self, force_reload: bool = False) -> LuaApi:
        """Load the API definition from YAML."""
        if self._api is not None and not force_reload:
            return self._api

        api_path = self.get_api_path()

        with open(api_path) as f:
            raw_data = yaml.safe_load(f)

        # Parse the raw data into our models
        self._api = self._parse_api(raw_data)
        return self._api

    def _parse_api(self, data: dict) -> LuaApi:
        """Parse the raw YAML data into structured models."""
        # Parse namespaces
        namespaces = {}
        for ns_name, ns_data in data.get("namespaces", {}).items():
            functions = {}
            for fn_name, fn_data in ns_data.get("functions", {}).items():
                params = []
                for p in fn_data.get("params", []):
                    if isinstance(p, dict):
                        params.append(ParamDef(**p))
                    else:
                        # Handle simple param definitions
                        params.append(ParamDef(name=str(p), type="any"))

                functions[fn_name] = FunctionDef(
                    description=fn_data.get("description", ""),
                    params=params,
                    returns=fn_data.get("returns"),
                    status=fn_data.get("status", "not_implemented"),
                )
            namespaces[ns_name] = NamespaceDef(
                description=ns_data.get("description", ""), functions=functions
            )

        # Parse globals
        globals_dict = {}
        for fn_name, fn_data in data.get("globals", {}).items():
            params = []
            for p in fn_data.get("params", []):
                if isinstance(p, dict):
                    params.append(ParamDef(**p))
            globals_dict[fn_name] = FunctionDef(
                description=fn_data.get("description", ""),
                params=params,
                returns=fn_data.get("returns"),
                status=fn_data.get("status", "not_implemented"),
            )

        # Parse actor methods
        actor_methods = {}
        for fn_name, fn_data in data.get("actor", {}).items():
            params = []
            for p in fn_data.get("params", []):
                if isinstance(p, dict):
                    params.append(ParamDef(**p))
            actor_methods[fn_name] = FunctionDef(
                description=fn_data.get("description", ""),
                params=params,
                returns=fn_data.get("returns"),
                status=fn_data.get("status", "not_implemented"),
            )

        # Parse actor properties
        actor_props = {}
        for prop_name, prop_data in data.get("actor_properties", {}).items():
            actor_props[prop_name] = PropertyDef(
                type=prop_data.get("type", "any"),
                status=prop_data.get("status", "not_implemented"),
            )

        # Parse actor inventory methods
        actor_inv = {}
        for fn_name, fn_data in data.get("actor_inventory", {}).items():
            params = []
            for p in fn_data.get("params", []):
                if isinstance(p, dict):
                    params.append(ParamDef(**p))
            actor_inv[fn_name] = FunctionDef(
                description=fn_data.get("description", ""),
                params=params,
                returns=fn_data.get("returns"),
                status=fn_data.get("status", "not_implemented"),
            )

        # Parse room methods
        room_methods = {}
        for fn_name, fn_data in data.get("room", {}).items():
            params = []
            for p in fn_data.get("params", []):
                if isinstance(p, dict):
                    params.append(ParamDef(**p))
            room_methods[fn_name] = FunctionDef(
                description=fn_data.get("description", ""),
                params=params,
                returns=fn_data.get("returns"),
                status=fn_data.get("status", "not_implemented"),
            )

        # Parse room properties
        room_props = {}
        for prop_name, prop_data in data.get("room_properties", {}).items():
            room_props[prop_name] = PropertyDef(
                type=prop_data.get("type", "any"),
                status=prop_data.get("status", "not_implemented"),
            )

        # Parse quest methods
        quest_methods = {}
        for fn_name, fn_data in data.get("quest", {}).items():
            params = []
            for p in fn_data.get("params", []):
                if isinstance(p, dict):
                    params.append(ParamDef(**p))
            quest_methods[fn_name] = FunctionDef(
                description=fn_data.get("description", ""),
                params=params,
                returns=fn_data.get("returns"),
                status=fn_data.get("status", "not_implemented"),
            )

        return LuaApi(
            version=data.get("version", "1.0"),
            types=data.get("types", {}),
            error_codes=data.get("error_codes", []),
            namespaces=namespaces,
            globals=globals_dict,
            actor=actor_methods,
            actor_properties=actor_props,
            actor_inventory=actor_inv,
            room=room_methods,
            room_properties=room_props,
            quest=quest_methods,
            enums=data.get("enums", {}),
        )

    def has_namespace(self, namespace: str) -> bool:
        """Check if a namespace exists."""
        api = self.load()
        return namespace in api.namespaces

    def has_function(self, namespace: str, function: str) -> bool:
        """Check if a function exists in a namespace."""
        api = self.load()
        if namespace not in api.namespaces:
            return False
        return function in api.namespaces[namespace].functions

    def get_function(self, namespace: str, function: str) -> Optional[FunctionDef]:
        """Get a function definition from a namespace."""
        api = self.load()
        if namespace not in api.namespaces:
            return None
        return api.namespaces[namespace].functions.get(function)

    def has_global(self, function: str) -> bool:
        """Check if a global function exists."""
        api = self.load()
        return function in api.globals

    def get_global(self, function: str) -> Optional[FunctionDef]:
        """Get a global function definition."""
        api = self.load()
        return api.globals.get(function)

    def has_actor_method(self, method: str) -> bool:
        """Check if an actor method exists."""
        api = self.load()
        return method in api.actor

    def get_actor_method(self, method: str) -> Optional[FunctionDef]:
        """Get an actor method definition."""
        api = self.load()
        return api.actor.get(method)

    def has_room_method(self, method: str) -> bool:
        """Check if a room method exists."""
        api = self.load()
        return method in api.room

    def get_room_method(self, method: str) -> Optional[FunctionDef]:
        """Get a room method definition."""
        api = self.load()
        return api.room.get(method)

    def get_all_namespaces(self) -> list[str]:
        """Get all namespace names."""
        api = self.load()
        return list(api.namespaces.keys())

    def get_all_functions_in_namespace(self, namespace: str) -> list[str]:
        """Get all function names in a namespace."""
        api = self.load()
        if namespace not in api.namespaces:
            return []
        return list(api.namespaces[namespace].functions.keys())

    def is_implemented(self, namespace: str, function: str) -> bool:
        """Check if a namespace function is implemented."""
        fn = self.get_function(namespace, function)
        return fn is not None and fn.is_implemented()

    def get_unimplemented_functions(self) -> list[tuple[str, str]]:
        """Get all unimplemented namespace functions as (namespace, function) tuples."""
        api = self.load()
        unimplemented = []
        for ns_name, ns in api.namespaces.items():
            for fn_name, fn in ns.functions.items():
                if not fn.is_implemented():
                    unimplemented.append((ns_name, fn_name))
        return unimplemented


# Module-level convenience functions
def load_api() -> LuaApi:
    """Load and return the Lua API definition."""
    return LuaApiLoader().load()


def has_function(namespace: str, function: str) -> bool:
    """Check if a function exists in a namespace."""
    return LuaApiLoader().has_function(namespace, function)


def is_implemented(namespace: str, function: str) -> bool:
    """Check if a namespace function is implemented."""
    return LuaApiLoader().is_implemented(namespace, function)
