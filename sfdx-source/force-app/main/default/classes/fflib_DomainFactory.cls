/**
 * File Name: fflib_DomainFactory 
 * Description: Interface for the Domainfactory to be able to dynamically instantiate domains
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 *
 * Had to make this an abstract class and not an interface to enforce the availability of the private method setMock
 */
public abstract class fflib_DomainFactory
{
	abstract fflib_ISObjectDomain newInstance(Set<Id> recordIds);
	abstract fflib_ISObjectDomain newInstance(List<SObject> records);
	abstract fflib_ISObjectDomain newInstance(List<SObject> records, SObjectType domainSObjectType);
	abstract void replaceWith(SObjectType sObjectType, Object domainImpl);
	@TestVisible abstract void setMock(SObjectType sObjectType, Object mockImp);
}