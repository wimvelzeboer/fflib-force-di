/**
 * File Name: fflib_SelectorFactoryQueries 
 * Description: Standard query methods for the Selector Factory
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public abstract with sharing class fflib_SelectorFactoryQueries implements fflib_SelectorFactory
{

	/**
	 * Helper method to query the given SObject records
	 *   Internally creates an instance of the registered Selector and calls its
	 *     selectSObjectById method
	 *
	 * @param recordIds The SObject record Ids, must be all the same SObjectType
	 * @exception Is thrown if the record Ids are not all the same or the SObjectType is not registered
	 **/
	public List<SObject> selectById(Set<Id> recordIds)
	{
		// No point creating an empty Domain class, nor can we determine the SObjectType anyway
		if (recordIds == null || recordIds.size() == 0)
		{
			// todo - convert to label
			throw new fflib_DeveloperException('Label.fflib_InvalidRecordIdSet');
		}

		// Determine SObjectType
		Schema.SObjectType domainSObjectType = new List<Id>(recordIds)[0].getSobjectType();
		for (Id recordId : recordIds)
		{
			if (recordId.getSobjectType() != domainSObjectType)
			{
				// todo - convert to label
				throw new fflib_DeveloperException('Label.fflib_SetContainsIdsFromDifferentSObjectTypes');
			}
		}

		// Construct Selector class and query by Id for the records
		return newInstance(domainSObjectType).selectSObjectsById(recordIds);
	}

	/**
	 * Helper method to query related records to those provided, for example
	 *   if passed a list of Opportunity records and the Account Id field will
	 *   construct internally a list of Account Ids and call the registered
	 *   Account selector to query the related Account records, e.g.
	 *
	 *     List<Account> accounts =
	 *        (List<Account>) Application.Selector.selectByRelationship(myOpportunities, Opportunity.AccountId);
	 *
	 * @param relatedRecords used to extract the related record Ids, e.g. Opportunity records
	 * @param relationshipField field in the passed records that contains the relationship records to query, e.g. Opportunity.AccountId
	 **/
	public List<SObject> selectByRelationship(List<SObject> relatedRecords, SObjectField relationshipField)
	{
		Set<Id> relatedIds = new Set<Id>();
		for (SObject relatedRecord : relatedRecords)
		{
			Id relatedId = (Id) relatedRecord.get(relationshipField);
			if (relatedId != null)
			{
				relatedIds.add(relatedId);
			}
		}
		return selectById(relatedIds);
	}

	abstract fflib_ISObjectSelector newInstance(SObjectType sObjectType);
}