/**
 * File Name: fflib_DomainFactoryImp 
 * Description:  Domain factory for Domains configured as bindings to the force-di
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public virtual with sharing class fflib_DomainFactoryImp implements fflib_DomainFactory
{
	protected String appName;
	protected fflib_SelectorFactory selectorFactory;

	protected Map<Schema.SObjectType, Object> mocks;

	public fflib_DomainFactoryImp(String appName, fflib_SelectorFactory selectorFactory)
	{
		this.appName = appName.toLowerCase();
		this.selectorFactory = selectorFactory;
	}

	 /**
	  * newInstance
	  *
	  * @description Queries the records and constructs a new domain instance for the query result
	  *
	  * @param recordIds Record ids to register in the domain
	  * @throws fflib_DeveloperException when the SObjectType could not be retrieved from the List<SObject>,
	  * @throws fflib_DeveloperException when the implementation is null or its not an instance of fflib_SObjectDomain.IConstructable2
	  * @return Instance of a SObjectDomain class
	  */
	public fflib_ISObjectDomain newInstance(Set<Id> recordIds)
	{
		return newInstance(selectorFactory.selectById(recordIds));
	}

	/**
	 * newInstance
	 *
	 * @description Gets the SObjectType and constructs a new instance of the domain
	 * @param records Records to register in the domain
	 *
	 * @return SObjectDomain instance or the mocked version
	 * @throws fflib_DeveloperException when the SObjectType could not be retrieved from the List<SObject>,
	 * @throws fflib_DeveloperException when the implementation is null or its not an instance of fflib_SObjectDomain.IConstructable2
	 */
	public fflib_ISObjectDomain newInstance(List<SObject> records)
	{
		Schema.SObjectType sObjectType = records.getSObjectType();
		assertForValidSObjectType(sObjectType);
		return newInstance(records, sObjectType);
	}

	/**
	 * newInstance
	 *
	 * @description Gets the instance for the domain constructor from force-di and constructs a new domain
	 * @param records Records to register in the domain
	 * @param sObjectType The SObjectType of the provided records
	 *
	 * @return SObjectDomain instance or the mocked version
	 * @throws fflib_DeveloperException when the implementation is null or its not an instance of fflib_SObjectDomain.IConstructable2
	 */
	public fflib_ISObjectDomain newInstance(List<SObject> records, Schema.SObjectType sObjectType)
	{
		if (hasMock(sObjectType))
		{
			return newMockInstance(sObjectType);
		}

		Object implementation = getImplementationFromInjector(sObjectType);
		assertForDomainImplementation(implementation);
		return constructDomainInstance(implementation, records, sObjectType);
	}

	/**
	 * replaceWith
	 *
	 * @description Dynamically replace a domain implementation at runtime
	 * @param sObjectType The SObjectType linked to the domain
	 * @param domainImpl The new implementation of the domain
	 */
	public void replaceWith(SObjectType sObjectType, Object domainImpl)
	{
		di_Injector.Org.Bindings.byName(
				getBindingName(sObjectType)
		)
				.replaceBindingWith(domainImpl);
	}

	/**
	 * setMock
	 *
	 * @description Replace the implementation with a mock version
	 * @param sObjectType The SObjectType of the provided domain mock implementation
	 * @param domainImp The implementation to use for mocking
	 */
	public void setMock(Schema.SObjectType sObjectType, Object domainImp)
	{
		if (this.mocks == null)
		{
			this.mocks = new Map<Schema.SObjectType, Object>();
		}
		this.mocks.put(sObjectType, domainImp);
	}

	/**
	 * assertForDomainImplementation
	 *
	 * @param implementation Implementation returned by the binding to be validated
	 *
	 * @throws fflib_DeveloperException when the implementation is null or its not an instance of fflib_SObjectDomain.IConstructable2
	 */
	private void assertForDomainImplementation(Object implementation)
	{
		if (!(implementation instanceof fflib_SObjectDomain.IConstructable2) &&
				!(implementation instanceof fflib_SObjectDomain.IConstructable))
		{
			// todo - convert to label
			throw new fflib_DeveloperException('Label.fflib_DomainConstructorShouldBeIConstructable2');
		}
	}

	/**
	 * assertForValidSObjectType
	 *
	 * @param sObjectType
	 *
	 * @throws fflib_DeveloperException when the SObjectType could not be retrieved from the List<SObject>,
	 */
	private void assertForValidSObjectType(SObjectType sObjectType)
	{
		if (sObjectType == null)
		{
			// todo convert to label
			throw new fflib_DeveloperException('Label.fflib_UnableToDetermineSObjectType');
		}
	}

	/**
	 * constructDomainInstance
	 *
	 * @description Takes the constructorImplementation, cast it to the correct type and call the 'construct' method to create a new instance of the domain
	 *
	 * @param constructorImp
	 * @param records
	 * @param sObjectType
	 *
	 * @return instance of fflib_ISObjectDomain
	 */
	private fflib_ISObjectDomain constructDomainInstance(
			Object constructorImp,
			List<SObject> records,
			Schema.SObjectType sObjectType)
	{
		// For backwards compatibility
		if ( !(constructorImp instanceof fflib_SObjectDomain.IConstructable2) &&
		      (constructorImp instanceof fflib_SObjectDomain.IConstructable))
		{
			System.debug(System.LoggingLevel.WARN, 'DEPRECATED: Just IConstructable as Domain constructor is no longer support, please IConstructable2 instead');
			return (fflib_ISObjectDomain)
					(((fflib_SObjectDomain.IConstructable) constructorImp)
							.construct(records));
		}

		return (fflib_ISObjectDomain)
				(((fflib_SObjectDomain.IConstructable2) constructorImp)
						.construct(records, sObjectType));
	}

	/**
	 * getBindingName
	 *
	 * @description Constructs the binding name with; AppName, "domain" and SObjectType
	 * @param sObjectType The SObjectType for which to return the binding name
	 *
	 * @return The constructed binding name
	 *
	 * @example
	 * String bindingName = getBindingName(Account.SObjectType);
	 * System.debug(bindingName);   // "myApp.domain.Account"
	 */
	private String getBindingName(Schema.SObjectType sObjectType)
	{
		return this.appName + '.domain.' + sObjectType.getDescribe().getName();
	}

	/**
	 * getImplementationFromInjector
	 *
	 * @description Gets the bindingName for the provided SObjectType and requests an instance from force-di
	 * @param sObjectType
	 *
	 * @return Instance of fflib_ISObjectDomain.IConstructable2
	 */
	private Object getImplementationFromInjector(SObjectType sObjectType)
	{
		return di_Injector.Org.getInstance(
				getBindingName(sObjectType)
		);
	}

	/**
	 * hasMock
	 *
	 * @description Validate that the execution context is within an unit-test and checks if there is a mock registered
	 *
	 * @param sObjectType The SObjectType to validate
	 *
	 * @return Returns True if we are in a unit-test and a mock is registered for the given SObjectType
	 */
	private Boolean hasMock(Schema.SObjectType sObjectType)
	{
		return Test.isRunningTest() &&
				this.mocks != null &&
				this.mocks.containsKey(sObjectType);
	}

	/**
	 * newMockInstance
	 *
	 * @description Gets the mocked implementation for the given SObjectType
	 * @param sObjectType
	 *
	 * @return Instance of the mocked domain
	 */
	private fflib_ISObjectDomain newMockInstance(Schema.SObjectType sObjectType)
	{
		return (fflib_ISObjectDomain) this.mocks.get(sObjectType);
	}
}