/**
 * File Name: fflib_TriggerContext 
 * Description:
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public interface fflib_TriggerContext
{
	Schema.SObjectType getSObjectType();
	void setDomainFactory(fflib_DomainFactory domainFactory);
}