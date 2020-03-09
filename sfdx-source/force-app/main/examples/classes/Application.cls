/**
 * File Name: Application 
 * Description:
 * @author: architect ir. Wilhelmus G.J. Velzeboer | wvelzebo@its.jnj.com
 */
public with sharing class Application
{
	public static final String APP_NAME = 'MyForceApp';

	// Configure and create the UnitOfWorkFactory for this Application
	public static final fflib_Application.UnitOfWorkFactory UnitOfWork =
			new fflib_Application.UnitOfWorkFactory(
					new List<SObjectType>
					{
							Account.SObjectType,
							Contact.SObjectType
					});

	// Configure and create the ServiceFactory for this Application
	public static final fflib_ServiceFactory Service =	new fflib_ServiceFactoryImp();

	// Configure and create the SelectorFactory for this Application
	public static final fflib_SelectorFactory Selector = new fflib_SelectorFactoryImp(APP_NAME);

	// Configure and create the DomainFactory for this Application
	public static final fflib_DomainFactory Domain = new fflib_DomainFactoryImp(APP_NAME, Application.Selector);
}