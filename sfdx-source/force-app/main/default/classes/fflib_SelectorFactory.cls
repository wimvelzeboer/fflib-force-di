/**
 * File Name: fflib_SelectorFactory 
 * Description: Selector factory interface structure for returning new instances of selector layer classes
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public interface fflib_SelectorFactory
{
	fflib_ISObjectSelector newInstance(Schema.SObjectType sObjectType);
	void replaceWith(Schema.SObjectType sObjectType, Object selectorImpl);
	List<SObject> selectById(Set<Id> recordIds);
	List<SObject> selectByRelationship(List<SObject> relatedRecords, Schema.SObjectField relationshipField);

	// @Deprecated - only available for backwards compatibility
	void setMock(Object selectorImp);
}