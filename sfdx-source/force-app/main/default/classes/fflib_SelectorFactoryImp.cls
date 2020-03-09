/**
 * File Name: ffib_SelectorFactoryImp 
 * Description: Selectorctor factory implementation for returning new instances of selector layers registered in force-di
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public virtual with sharing class fflib_SelectorFactoryImp extends fflib_SelectorFactoryQueries
{
	protected String appName;

	public fflib_SelectorFactoryImp(String appName)
	{
		this.appName = appName.toLowerCase();
	}

	public fflib_ISObjectSelector newInstance(Schema.SObjectType sObjectType)
	{
		return (fflib_ISObjectSelector) di_Injector.Org.getInstance(
				getBindingName(sObjectType)
		);
	}

	public void replaceWith(Schema.SObjectType sObjectType, Object selectorImpl)
	{
		di_Injector.Org.Bindings.byName(getBindingName(sObjectType)).replaceBindingWith(selectorImpl);
	}

	private String getBindingName(Schema.SObjectType sObjectType)
	{
		return this.appName + '.selector.' + sObjectType.getDescribe().getName();
	}
}