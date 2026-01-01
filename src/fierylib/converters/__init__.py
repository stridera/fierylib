"""
Converters module - ID conversion, flag normalization, skill name mapping, and color code conversion
"""

from .id_converter import (
    vnum_to_composite,
    legacy_id_to_composite,
    composite_to_legacy_id,
    convert_zone_id,
    CompositeId,
    EntityResolver,
)
from .flag_normalizer import normalize_flag, normalize_flags
from .skill_name_normalizer import normalize_skill_name, denormalize_skill_name
from .color_converter import convert_legacy_colors, strip_legacy_colors, strip_markup, ColorConverter
from .keyword_normalizer import strip_articles, normalize_keywords

__all__ = [
    "vnum_to_composite",
    "legacy_id_to_composite",
    "composite_to_legacy_id",
    "convert_zone_id",
    "CompositeId",
    "EntityResolver",
    "normalize_flag",
    "normalize_flags",
    "normalize_skill_name",
    "denormalize_skill_name",
    "convert_legacy_colors",
    "strip_legacy_colors",
    "strip_markup",
    "ColorConverter",
    "strip_articles",
    "normalize_keywords",
]
