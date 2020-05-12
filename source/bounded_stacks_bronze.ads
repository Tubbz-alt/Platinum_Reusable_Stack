------------------------------------------------------------------------------
--                                                                          --
--                     Copyright (C) 2020, AdaCore                          --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
------------------------------------------------------------------------------

generic
   type Element is private;
   --  The type of values contained by objects of type Stack

   Default_Value : Element;
   --  The default value used for stack contents. Never
   --  acquired as a value from the API, but required for
   --  initialization in SPARK.
package Bounded_Stacks_Bronze is

   type Stack (Capacity : Positive) is private;

   procedure Push (This : in out Stack; Item : in Element) with
     Pre    => not Full (This),
     Global => null;

   procedure Pop (This : in out Stack; Item : out Element) with
     Pre    => not Empty (This),
     Global => null;

   function Top_Element (This : Stack) return Element with
     Pre    => not Empty (This),
     Global => null;
   --  Returns the value of the Element at the "top" of This
   --  stack, i.e., the most recent Element pushed. Does not
   --  remove that Element or alter the state of This stack
   --  in any way.

   overriding function "=" (Left, Right : Stack) return Boolean with
     Global => null;

   procedure Copy (Destination : in out Stack; Source : Stack) with
     Pre    => Destination.Capacity >= Extent (Source),
     Global => null;
   --  An alternative to predefined assignment that does not
   --  copy all the values unless necessary. It only copies
   --  the part "logically" contained, so is more efficient
   --  when Source is not full.

   function Extent (This : Stack) return Natural with
     Global => null;
   --  Returns the number of Element values currently
   --  contained within This stack.

   function Empty (This : Stack) return Boolean with
     Global => null;

   function Full (This : Stack) return Boolean with
     Global => null;

   procedure Reset (This : in out Stack) with
     Global => null;

private

   type Content is array (Positive range <>) of Element;

   type Stack (Capacity : Positive) is record
      Values : Content (1 .. Capacity) := (others => Default_Value);
      Top    : Natural := 0;
   end record;

end Bounded_Stacks_Bronze;
