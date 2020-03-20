/**
 * File Name: fflib_DomainFactory 
 * Description: Interface for the Domainfactory to be able to dynamically instantiate domains
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 *
 * Had to make this an abstract class and not an interface to enforce the availability of the private method setMock
 */
public interface fflib_DomainFactory
{
	fflib_ISObjectDomain newInstance(Set<Id> recordIds);
	fflib_ISObjectDomain newInstance(List<SObject> records);
	fflib_ISObjectDomain newInstance(List<SObject> records, SObjectType domainSObjectType);
	void replaceWith(SObjectType sObjectType, Object domainImpl);

	// @Deprecated - only available for backwards compatibility
	void setMock(Object selectorImp);
}