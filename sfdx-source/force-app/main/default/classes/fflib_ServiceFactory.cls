/**
 * File Name: fflib_ServiceFactory
 * Description: Service factory interface structure for returning new instances of services
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public interface fflib_ServiceFactory
{
	Object newInstance(Type serviceInterfaceType);
	void replaceWith(Type serviceInterfaceType, Object serviceImpl);

	// @Deprecated - only available for backwards compatibility
	void setMock(Type serviceInterfaceType, Object serviceImp);
}