"""
Layout Module - Auto-generates x,y,z coordinates for MUD rooms

This module provides tools to automatically layout MUD rooms in 3D space
based on their directional connections (north, south, east, west, up, down).
"""

from .config import LayoutConfig
from .layout_engine import LayoutEngine

__all__ = ["LayoutConfig", "LayoutEngine"]
