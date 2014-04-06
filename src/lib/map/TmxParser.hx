package lib.map;

class TmxParser
{

	public function new() { }
	
	static function __init__()
	{
		
	}
	
	static public function parseObjects(tmx : String) : Array<TmxObject>
	{
		var objects : Array<TmxObject> = new Array<TmxObject>();

		var XML : Xml = Xml.parse(tmx);
		XML = XML.firstElement();
		for (element in XML.elements())
		{
			if (element.nodeName == "objectgroup")
			{
				for (ob in element.elements())
				{
					if (ob.nodeName == "object")
					{
						var newOb : TmxObject = new TmxObject();
						newOb.name = ob.get("name");
						newOb.type = ob.get("type");
						newOb.position.x = Std.parseFloat(ob.get("x"));
						newOb.position.y = Std.parseFloat(ob.get("y"));
						newOb.bounds.x = Std.parseFloat(ob.get("width"));
						newOb.bounds.y = Std.parseFloat(ob.get("height"));
						for (props in ob.elementsNamed("properties"))
						{
							for (prop in props.elements())
							{
								newOb.properties.set(prop.get("name"), prop.get("value"));
							}
						}
						objects.push(newOb);
					}
				}
			}
		}
		
		return objects;
	}

}