/**
 * File Name: fflib_TriggerSObjectContext
 * Description: Trigger Context for handling SObjects
 *
 * @author : architect ir. Wilhelmus G.J. Velzeboer
 */
public virtual with sharing class fflib_TriggerContextSObject implements fflib_TriggerContext
{
	protected Schema.SObjectType sObjectType;
	protected fflib_DomainFactory domainFactory;

	@TestVisible
	protected Map<Id, SObject> existingRecords
	{
		get
		{
			if (existingRecords == null)
			{
				existingRecords = Trigger.oldMap;
			}
			return existingRecords;
		}
		set;
	}

	// Lazy loading of trigger operationType
	protected System.TriggerOperation operationType
	{
		get
		{
			if (operationType == null)
			{
				operationType = Trigger.operationType;
			}
			return operationType;
		}
		set;
	}

	// Lazy loading of records
	@TestVisible
	protected List<SObject> records
	{
		get
		{
			if (records == null)
			{
				if (operationType == System.TriggerOperation.AFTER_DELETE ||
						operationType == System.TriggerOperation.BEFORE_DELETE)
				{
					records = Trigger.oldMap.values();
				}
				records = Trigger.New;
			}
			return records;
		}
		set;
	}

	/**
	 * Class constructor
	 *
	 * @param sObjectType
	 */
	public fflib_TriggerContextSObject(Schema.SObjectType sObjectType)
	{
		this.sObjectType = sObjectType;
	}

	/**
	 * Gets the equivalent of Trigger.oldMap
	 *
	 * @return A map with Records by its Id
	 * @example
	 * public with sharing class MyBusinessLogic extends fflib_TriggerActionSObject
	 * {
	 *      public override void onBeforeUpdate(fflib_TriggerContextSObject ctx)
	 *      {
	 *          List<SObject> oldMap = ctx.getExistingRecords();
	 *          ...
	 *      }
	 * }
	 */
	public virtual Map<Id, SObject> getExistingRecords()
	{
		return this.existingRecords;
	}

	/**
	 * Get the current trigger operation type
	 *
	 * @return The current Trigger operation type (System.TriggerOperation)
	 *
	 * @example
	 * public with sharing class MyBusinessLogic extends fflib_TriggerActionSObject
	 * {
	 *      public override void run(fflib_TriggerContextSObject ctx)
	 *      {
	 *          if (ctx.getOperationType == BEFORE_INSERT)
	 *          {
	 *              ...
	 *          }
	 *      }
	 * }
	 */
	public virtual System.TriggerOperation getOperationType()
	{
		return this.operationType;
	}

	/**
	 * Get a Domain class containing the records processes by the trigger (Trigger.new)
	 *
	 * @return Instance of fflib_ISObjectDomain with the records
	 *
	 * @example
	 * public with sharing class AccountBusinessLogic extends fflib_TriggerActionSObject
	 * {
	 *      public override void onBeforeUpdate(fflib_TriggerContextSObject ctx)
	 *      {
	 *          Accounts accounts = (Accounts) ctx.getDomain();
	 *          accounts.selectByPopulatedCountry()
	 *                  .upperCaseCountriesFirstCharacter();
	 *      }
	 * }
	 */
	public virtual fflib_ISObjectDomain getDomain()
	{
		return domainFactory.newInstance(this.records, this.sObjectType);
	}

	/**
	 * Gets the Schema.SObjectType of the records, useful for dynamic handling of implementations
	 *
	 * @return The Schema.SObjectType of the records being processed
	 */
	public SObjectType getSObjectType()
	{
		return this.sObjectType;
	}

	/**
	 * Detects whether any values in context records have changed for given fields as strings
	 * Returns list of SObject records that have changes in the specified fields
	 *
	 * @param fieldNames A list of field names to check if they were changed
	 *
	 * @return Instance of fflib_ISObjectDomain with the records where one or more of the given fields were changed
	 *
	 * @example
	 * public with sharing class AccountBusinessLogic extends fflib_TriggerActionSObject
	 * {
	 *      public override void onBeforeUpdate(fflib_TriggerContextSObject ctx)
	 *      {
	 *          Accounts accounts = (Accounts) ctx.getChangedRecords(new Set<String>{'ShippingCountry'});
	 *
	 *          if (account.isEmpty()) return;
	 *
	 *          Map<Id, String> countryByAccountId = accounts.getCountryById();
	 *
	 *          ((Contacts) Application.Service.newInstance(Contacts.class))
	 *                  .syncCountryFromAccount(countryByAccountId);
	 *      }
	 * }
	 **/
	public fflib_ISObjectDomain getChangedRecords(Set<String> fieldNames)
	{
		List<SObject> changedRecords = new List<SObject>();
		for (SObject newRecord : records)
		{
			Id recordId = (Id) newRecord.get('Id');
			if (this.existingRecords == null || !this.existingRecords.containsKey(recordId))
			{
				continue;
			}

			SObject oldRecord = this.existingRecords.get(recordId);
			for (String fieldName : fieldNames)
			{
				if (oldRecord.get(fieldName) != newRecord.get(fieldName))
				{
					changedRecords.add(newRecord);
					break;  // prevents the records from being added multiple times
				}
			}
		}
		return domainFactory.newInstance(changedRecords, this.sObjectType);
	}

	/**
	 * Detects whether any values in context records have changed for given fields as tokens
	 * Returns list of SObject records that have changes in the specified fields
	 *
	 * @param fieldTokens A list of fields to check if they were changed
	 *
	 * @return Instance of fflib_ISObjectDomain with the records where one or more of the given fields were changed
	 *
	 * @example
	 * public with sharing class AccountBusinessLogic extends fflib_TriggerActionSObject
	 * {
	 *      public override void onBeforeUpdate(fflib_TriggerContextSObject ctx)
	 *      {
	 *          Accounts accounts = (Accounts) ctx.getChangedRecords(new Set<Schema.SObjectField>
	 *              {
	 *                  Schema.Account.ShippingCountry
	 *              });
	 *
	 *          if (account.isEmpty()) return;
	 *
	 *          Map<Id, String> countryByAccountId = accounts.getCountryById();
	 *
	 *          ((Contacts) Application.Service.newInstance(Contacts.class))
	 *                  .syncCountryFromAccount(countryByAccountId);
	 *      }
	 * }
	 **/
	public fflib_ISObjectDomain getChangedRecords(Set<Schema.SObjectField> fieldTokens)
	{
		List<SObject> changedRecords = new List<SObject>();
		for (SObject newRecord : Records)
		{
			Id recordId = (Id) newRecord.get('Id');
			if (this.existingRecords == null || !this.existingRecords.containsKey(recordId))
			{
				continue;
			}
			SObject oldRecord = this.existingRecords.get(recordId);
			for (Schema.SObjectField fieldToken : fieldTokens)
			{
				if (oldRecord.get(fieldToken) != newRecord.get(fieldToken))
				{
					changedRecords.add(newRecord);
					break;  // prevents the records from being added multiple times
				}
			}
		}
		return domainFactory.newInstance(changedRecords, this.sObjectType);
	}

	public void setDomainFactory(fflib_DomainFactory domainFactory)
	{
		this.domainFactory = domainFactory;
	}
}