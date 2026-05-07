-- Trigger: TD PY Init
-- Zone: 49, ID: 5
-- Type: OBJECT, Flags: DROP
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #4905
-- Original: OBJECT trigger, flags: DROP, probability: 100%
--
-- Per-pylon initialization. Establishes per-instance state: which pylon
-- index this is (0..pylons-1), the current owner team (-1 = unowned), and
-- a snapshot of the pylon name. The pylon index defaults to 0; a builder
-- sets the actual index by editing self.state.pylon at spawn time.
--
-- TODO(converter): the legacy DG version assigned all of these as object-
-- scoped globals on drop. In the Rust runtime use self.state for per-
-- instance persistence. Confirm the pylon index assignment path -- this
-- file used to hardcode pylon=0, which is wrong if multiple pylons exist.

self.state = self.state or {}
self.state.teams = 4
self.state.owner = self.state.owner or -1
self.state.pylonname = "Caelian Pylon"
self.state.pylon = self.state.pylon or 0
return true
