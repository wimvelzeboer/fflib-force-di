/**
 * File Name: fflib_TriggerChangeEventContext 
 * Description: Abstract Trigger Action for handling business logic triggered by ChangeEvents of DML Operations
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public virtual with sharing class fflib_TriggerContextChangeEvent implements fflib_TriggerContext
{
	protected Schema.SObjectType sObjectType;
	protected fflib_DomainFactory domainFactory;

	/**
	 * Class constructor
	 */
	public fflib_TriggerContextChangeEvent(Schema.SObjectType sObjectType)
	{
		this.sObjectType = sObjectType;
	}

	public fflib_ISObjectDomain getChanged()
	{
		// todo
		return null;
	}

	public SObjectType getSObjectType()
	{
		return this.sObjectType;
	}

	public void setDomainFactory(fflib_DomainFactory domainFactory)
	{
		this.domainFactory = domainFactory;
	}

}