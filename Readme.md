NSKeyedArchiver Bug Apportable
=================

Description
-----------

NSKeyedArchiver bombs out when archiving an NSMutableArray with 128 objects.  Seems rather suspicious being a power of 2, although my original app crashed at 64 objects however those objects had more properties (although not significantly) so it could possibly be a size issue?

Recreate
-----------
Just run 'apportable load' (device connected)
Grep 'apportable log' for NSLog, then hit Start Test menu item.

All works fine in iOS as expected.
  
