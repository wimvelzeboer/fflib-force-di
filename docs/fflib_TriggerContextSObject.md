# fflib-force-di

## fflib Trigger Context SObject

Virtual implementation of a trigger context for regular DML operations on SObjects

### Method reference

 - [getExistingRecords](#getexistingrecords)
 <br/>Returns the equivalent of Trigger.oldMap
 - [getOperationType](#getOperationType)
 <br/>Get the current trigger operation type
 - [getDomain](#getDomain)
 <br/>Get a Domain class containing the records processes by the trigger (Trigger.new)
 - [getChangedRecords](#getChangedRecords)
 <br/>Detects whether any values in context records have changed for given fields as tokens



#### getExistingRecords
```apex
virtual Map<Id, SObject> getExistingRecords();
```
Returns the equivalent of Trigger.oldMap
###### Examples
```apex
public with sharing class MyBusinessLogic extends fflib_TriggerActionSObject
{
    public override void onBeforeUpdate(fflib_TriggerContextSObject ctx)
    {
        List<SObject> oldMap = ctx.getExistingRecords();
        ...
    }
}
```


#### getOperationType
```apex
virtual System.TriggerOperation getOperationType()
```
Get the current trigger operation type
###### Examples
```apex
public with sharing class MyBusinessLogic extends fflib_TriggerActionSObject
{
    public override void run(fflib_TriggerContextSObject ctx)
    {
        if (ctx.getOperationType == BEFORE_INSERT)
        {
            ...
        }
    }
}
```


#### getDomain
```apex
virtual fflib_ISObjectDomain getDomain()
```
Get a Domain class containing the records processes by the trigger (Trigger.new)
###### Examples
```apex
public with sharing class AccountBusinessLogic extends fflib_TriggerActionSObject
{
    public override void onBeforeUpdate(fflib_TriggerContextSObject ctx)
    {
        Accounts accounts = (Accounts) ctx.getDomain();
        accounts.selectByPopulatedCountry()
            .upperCaseCountriesFirstCharacter();
    }
}
```


#### getChangedRecords
```apex
fflib_ISObjectDomain getChangedRecords(Set<String> fieldNames);
fflib_ISObjectDomain getChangedRecords(Set<Schema.SObjectField> fieldTokens);
```
Detects whether any values in context records have changed for given fields as tokens
###### Examples
```apex
public with sharing class AccountBusinessLogic extends fflib_TriggerActionSObject
{
    public override void onBeforeUpdate(fflib_TriggerContextSObject ctx)
    {
        Accounts accounts = (Accounts) ctx.getChangedRecords(new Set<Schema.SObjectField>
                {
                        Schema.Account.ShippingCountry
                });
        
        if (account.isEmpty()) return;
    
        Map<Id, String> countryByAccountId = accounts.getCountryById();
    
        ((Contacts) Application.Service.newInstance(Contacts.class))
                .syncCountryFromAccount(countryByAccountId);
    }
}
```


