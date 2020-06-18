/**
 * File Name: di_Bindings 
 * Description: Domain class for Di Bindinds
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public virtual with sharing class di_Bindings
{
	protected List<di_Binding> items;

	public di_Bindings(List<di_Binding> bindings)
	{
		this.items = bindings;
	}

	public Objects newInstances()
	{
		List<Object> result = new List<Object>();
		for (di_Binding binding : this.items)
		{
			result.add(
					binding.getInstance()
			);
		}
		return new Objects(result);
	}
}