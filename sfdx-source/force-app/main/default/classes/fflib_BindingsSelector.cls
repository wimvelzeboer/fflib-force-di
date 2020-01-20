/**
 * File Name: fflib_BindingsSelector 
 * Description: Selector for the Custom Metadata object fflib_Binding__mdt
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public without sharing class fflib_BindingsSelector extends fflib_SObjectSelector
{
	public List<Schema.SObjectField> getSObjectFieldList()
	{
		return new List<Schema.SObjectField>
		{
				fflib_Binding__mdt.Id,
				fflib_Binding__mdt.AppName__c,
				fflib_Binding__mdt.BindingObjectAlternate__c,
				fflib_Binding__mdt.BindingObject__c,
				fflib_Binding__mdt.BindingSequence__c,
				fflib_Binding__mdt.DeveloperName,
				fflib_Binding__mdt.NamespacePrefix,
				fflib_Binding__mdt.QualifiedAPIName,
				fflib_Binding__mdt.To__c,
				fflib_Binding__mdt.Type__c
		};
	}

	public Schema.SObjectType getSObjectType()
	{
		return fflib_Binding__mdt.SObjectType;
	}

	public List<fflib_Binding__mdt> selectById(Set<Id> idSet)
	{
		return (List<fflib_Binding__mdt>) selectSObjectsById(idSet);
	}

	public fflib_Bindings selectAll()
	{
		return new fflib_Bindings(Database.query(newQueryFactory().toSOQL()));
	}
}