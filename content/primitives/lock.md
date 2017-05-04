+++
title = "Lock"

[menu.main]
identifier = "lock"
parent = "primitives"
+++

A lock is a mechanism used to guarantee that shared data can only be accessed by one process (or thread within a process) at a time. Locks have default and configurable expirations.

## Actions

### Acquire

Try to get an exclusive lock on the specified resource.

### Release

Release the lock on the specified resource.

