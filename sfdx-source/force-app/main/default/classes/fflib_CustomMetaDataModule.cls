/**
 * File Name: fflib_di_CustomMetaDataModule 
 * Description: Dependency Injection module to register the bindings
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public with sharing class fflib_CustomMetaDataModule extends di_Module
{
	private String bindingObjectApiName = null;

	/**
	 * Lazy loading instance of the selector to query the bindings
	 */
	@TestVisible
	private static fflib_BindingsSelector bindingsSelector
	{
		get
		{
			if (bindingsSelector == null)
			{
				bindingsSelector = new fflib_BindingsSelector();
			}
			return bindingsSelector;
		}
		set;
	}

	/**
	 * Lazy loading instance of the domain containing the bindings
	 */
	@testVisible
	private fflib_Bindings bindings
	{
		get
		{
			if (bindings == null)
			{
				bindings = bindingsSelector.selectAll();
			}
			return bindings;
		}
		set;
	}

	/**
	 * configure
	 *
	 * @description iterate through the bindings and register them to force-di
	 */
	public override void configure()
	{
		for (fflib_Bindings.Binding binding : bindings.getBindings())
		{
			bind(binding.getName());

			Integer bindingSequence = binding.getSequence();
			if (bindingSequence != null)
			{
				sequence(bindingSequence);
			}
			data(binding.getRecord());
			to(binding.getTo());
		}
	}
}