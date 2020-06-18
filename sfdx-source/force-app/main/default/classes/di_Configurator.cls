/**
 * File Name: di_Configurator 
 * Description: Di Module to make it easy to configure a Di binding on the fly
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 *
 * @example
 *
 * // We have an interface named MyClass.cls and an implementation named MyClassImp.cls
 *
 * // to create the binding
 * di_Configurator.createApexBinding(MyClass.class, MyClassImp.class);
 *
 * // to get an instance of the binding
 * di_Injector.Org.getInstance(MyClass.class)
 */
public with sharing class di_Configurator
{
	/**
	 * Private Class constructor to prevent instantiation
	 */
	private di_Configurator(){}

	/**
	 * createApexBinding
	 *
	 * @description Registers a new module in the Di Injector for the given binding and implementation
	 * @param bindingName The binding or interface name to register
	 * @param implementation The implementation for the binding
	 */
	public static void createApexBinding(String bindingName, Type implementation)
	{
		createApexBinding(
				new Map<String, Type>{ bindingName => implementation }
		);
	}

	/**
	 * createApexBinding
	 *
	 * @description Registers a new module in the Di Injector for the given binding and implementation
	 * @param binding The binding type or interface name to register
	 * @param implementation The implementation for the binding
	 */
	public static void createApexBinding(Type binding, Type implementation)
	{
		createApexBinding(
				new Map<String, Type>{ binding.getName() => implementation }
		);
	}

	/**
	 * createApexBinding
	 *
	 * @description Registers a new module in the Di Injector for the given binding and implementation
	 * @param implementationByBindingName A map with implementation type by binding or interface name
	 */
	public static void createApexBinding(Map<String, Type> implementationByBindingName)
	{
		di_Injector.Org.Bindings.add(
				(di_Module) new ApexModule(implementationByBindingName)
		);
	}

	/**
	 * ApexModule The module used to register the new bindings
	 */
	private class ApexModule extends di_Module
	{
		private Map<String, Type> implementationByBindingName;

		public ApexModule(Map<String, Type> implementationByBindingName)
		{
			this.implementationByBindingName = implementationByBindingName;
		}

		/**
		 * configure
		 *
		 * @description Adds the bindings to the Di Injector
		 */
		public override void configure()
		{
			for (String bindingName : implementationByBindingName.keySet())
			{
				bind(bindingName).apex().to(implementationByBindingName.get(bindingName));
			}
		}
	}
}