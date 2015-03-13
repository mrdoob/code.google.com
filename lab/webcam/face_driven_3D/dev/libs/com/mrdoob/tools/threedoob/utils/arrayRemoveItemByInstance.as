package com.mrdoob.tools.threedoob.utils
{
	public function arrayRemoveItemByInstance(array : Array, item : Object) : void
	{
		var length : uint = array.length;
		 
		for(var i : Number = length; i > -1; i-- )
			if (array[i] === item)
				array.splice(i, 1);
	}
}
