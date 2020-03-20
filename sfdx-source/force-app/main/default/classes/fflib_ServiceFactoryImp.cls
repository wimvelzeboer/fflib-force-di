/**
 * File Name: fflib_ServiceFactoryImp 
 * Description: Service factory interface structure for returning new instances of services registered in force-di
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public with sharing class fflib_ServiceFactoryImp implements fflib_ServiceFactory
{
	/**
	 * Returns a new instance of the Apex class associated with the given Apex interface
	 *   Will return any mock implementation of the interface provided via setMock
	 *   Note that this method will not check the configured Apex class actually implements the interface
	 *
	 * @param serviceInterfaceType Apex interface type
	 * @exception Is thrown if there is no registered Apex class for the interface type
	 **/
	public Object newInstance(Type serviceInterfaceType)
	{
		return di_Injector.Org.getInstance(serviceInterfaceType);
	}

	public void replaceWith(Type serviceInterfaceType, Object serviceImpl)
	{
		di_Injector.Org.Bindings.byName(serviceInterfaceType.getName()).replaceBindingWith(serviceImpl);
	}

	// @Deprecated - only available for backwards compatibility
	public void setMock(Type serviceInterfaceType, Object serviceImp)
	{s
		System.debug(System.LoggingLevel.WARN, 'setMock is deprecated and replaced for replaceWith');
		replaceWith(serviceInterfaceType, serviceImp);
	}
}