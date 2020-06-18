/**
 * File Name: fflib_DomainFactory 
 * Description: Interface for the Domain factory to be able to dynamically instantiate domains
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public interface fflib_DomainFactory
{
	/**
	 * newInstance
	 * @description Queries the records and constructs a new domain instance for the query result
	 * @param recordIds Record ids to register in the domain
	 * @return Instance of a SObjectDomain class
	 */
	fflib_ISObjectDomain newInstance(Set<Id> recordIds);
	/**
	 * newInstance
	 * @description Gets the SObjectType and constructs a new instance of the domain
	 * @param records Records to register in the domain
	 * @return SObjectDomain instance or the mocked version
	 */
	fflib_ISObjectDomain newInstance(List<SObject> records);
	/**
	 * newInstance
	 * @description Gets the instance for the domain constructor from force-di and constructs a new domain
	 * @param records Records to register in the domain
	 * @param sObjectType The SObjectType of the provided records
	 * @return SObjectDomain instance or the mocked version
	 */
	fflib_ISObjectDomain newInstance(List<SObject> records, SObjectType sObjectType);
	/**
	 * replaceWith
	 *
	 * @description Dynamically replace a domain implementation at runtime
	 * @param sObjectType The SObjectType linked to the domain
	 * @param domainImpl The new implementation of the domain
	 */
	void replaceWith(SObjectType sObjectType, Object domainImpl);
	/**
	 * setMock
	 * @description Replace the implementation with a mock version
	 * @param sObjectType The SObjectType of the provided domain mock implementation
	 * @param domainImp The implementation to use for mocking
	 */
	void setMock(Schema.SObjectType sObjectType, Object domainImp);
}