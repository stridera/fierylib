"""%time.stamp% counts game hours in legacy DG (75 s each); Lua `time.stamp` is unix seconds,
so the converter maps it to `timestamp()` (game hours)."""

from fierylib.converters.dg_to_lua import convert_script_body, convert_variable_expr


def test_time_stamp_maps_to_timestamp():
    assert convert_variable_expr("time.stamp") == "timestamp()"
    lua = convert_script_body("eval now %time.stamp%\nset expire %now% + 1\n")
    assert "timestamp()" in lua
    assert "time.stamp" not in lua


def test_time_hour_untouched():
    assert convert_variable_expr("time.hour") == "time.hour"
