/**
 * File Name: Objects 
 * Description:
 * @author: architect ir. Wilhelmus G.J. Velzeboer | wvelzebo@its.jnj.com 
 */
public with sharing class Objects
{
	// The items in this domain
	protected List<Object> items;

	/**
	 * Class constructor
	 */
	public Objects(List<Object> objects)
	{
		this.items = objects;
	}

	public List<Object> get()
	{
		return this.items;
	}

	public Objects filter(FilterVisitor visitor)
	{
		List<Object> result = new List<Object>();
		for (Object item : this.items)
		{
			if (visitor.validate(item))
			{
				result.add(item);
			}
		}
		return new Objects(result);
	}

	public Boolean isEmpty()
	{
		return this.items.isEmpty();
	}

	public interface FilterVisitor
	{
		Boolean validate(Object obj);
	}
}