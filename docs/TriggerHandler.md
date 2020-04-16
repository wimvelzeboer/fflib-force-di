# fflib-force-di

## Trigger Handler

- [Introduction](#introduction)
- [Technical Design](#technical-design)
- [Configuring the Application Router](#configuring-the-application-router)
- [Adding a Trigger Handler](#adding-a-trigger-handler)
    - [Creating a Trigger Handler class](#creating-a-class)
    - [Register Trigger Handlers](#register-a-trigger-handler)
    - [Invoking the Trigger Handler](#invoking-the-trigger-handler)
- [Trigger handler types](#trigger-handlers-types)
    - [SObject trigger handlers](#sobject-trigger-handler)
    - [Change Event trigger handlers](#changeevent-trigger-handler)
    - [Platform Event trigger handlers](#platformevent-trigger-handler)
- [Trigger Context](#trigger-context)
    - [SObject trigger context](#sobject-trigger-context)
    - [Change Event trigger context](#change-event-trigger-context)
    - [Platform Event trigger context](#platform-event-trigger-context)
- [Examples](#examples)
    - [Conditional SObject Trigger](#conditional-sobject-trigger)
    - [Traditional Apex Enterprise Patterns SObject Trigger](#traditional-apex-enterprise-patterns-sobject-trigger)
    - [Trigger requiring input from related records](#trigger-requiring-input-from-related-records)
    - [Trigger listening to changed fields](#trigger-listening-to-changed-fields)
        - [Perform logic on the changed record](#perform-logic-on-the-changed-record)
        - [Perform logic outside the scope of the changed record](#perform-logic-outside-the-scope-of-the-changed-record) 

### Introduction
The trigger handler enables the separation of the business logic that is 
automatically executed after a DML statement.
Every bit of business logic has its own handler and is not combined with other logic,
which makes it easy to modify or remove it without having to worry about dependencies.
The logic can also be replace by a different version during runtime based on criteria.

### Technical design
The handler supports three types of triggers; the standard SObject trigger, 
ChangeEvents and Platform events.
Every individual trigger handlers with business logic are supported by a trigger context (ctx).
Depending on the type of trigger (sObject, ChangeEvent, PlatformEvent), 
it will support the handler with input to make the handler more effective.

Every trigger handler with a single piece of business logic extended from `fflib_TriggerHandler`.
Once a trigger executes it will call the `triggerHandler` factory on the `Application` class.
That factory will search for registered bindings in `di_Binding__mdt` linked to the SObjectType.
It will initialise the Trigger Context (ctx) and then iterate of the handlers to 
perform pre steps 
These pre steps can for example register an interest in related records in the ctx,
this is to avoid each individual handler to perform a query on its own.
After the pre steps the business logic of the handlers will be executed.

### Configuring the Application router
The main trigger handler factory will be invoked from the `Application` class.
That factory will generate instances of all the individual business logic trigger handlers.
The Trigger Context is initialised to populated it with the relevant information for the handlers.
Then the pre method `void pre(fflib_TriggerContext ctx);` is called on all the trigger handlers to invoke the pre steps.
Finally the handler method `void handle(fflib_TriggerContext ctx);` is called to execute the actual business logic.

###### Application routing class
```apex
public class Application
{
    public static final String APP_NAME = 'MyApp'; // The name of the application

    // The Selector factory
    public final fflib_SelectorFactory Selector = new fflib_SelectorFactoryImp(APP_NAME);

    // The Domain factory
    public final fflib_DomainFactory Domain =
            new fflib_DomainFactoryImp(APP_NAME, Selector);

    // The TriggerHandler factory
    public final fflib_TriggerHandlerFactory TriggerHandler =
            new fflib_TriggerHandlerFactoryImp(APP_NAME, Domain);
}
```

### Adding a trigger handler 
To add business logic we have to create a class and register it in the Force-Di bindings.

#### Creating a class
A handler for a specific piece of business logic will be a separate class extended from `fflib_TriggerHandler`.
It contains two methods; pre and handle. The pre method is to initialize the handler. 
It can utilize the Trigger Context (ctx) to perform initialisation steps on a higher level.
The handle method will contain the actual business logic.
```apex
public with sharing class MyBusinessLogic implements fflib_TriggerHandler
{
    public override void pre(fflib_TriggerContext ctx) {}

    public override void handle(fflib_TriggerContext ctx)
    {
       // Add your logic here
    }
}
```

#### Register a Trigger Handler
The standard Force-Di binding (`di_Binding__mdt`) is used to register a trigger handler.
A Handler is registered with the Type__c set to 'Apex', 
assigned to a Binding Object or Alternate object 
and with a certain execution order sequence number.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Account Trigger - Logic A</label>
    <protected>false</protected>
    <values>
        <field>BindingObject__c</field>
        <value xsi:type="xsd:string">Account</value>
    </values>
    <values>
        <field>BindingSequence__c</field>
        <value xsi:type="xsd:integer">7</value>
    </values>
    <values>
        <field>To__c</field>
        <value xsi:type="xsd:string">AccountTriggerHandlerA</value>
    </values>
    <values>
        <field>Type__c</field>
        <value xsi:type="xsd:string">Apex</value>
    </values>
</CustomMetadata>
```

### Invoking the trigger handler
The trigger is invoked via a standard trigger calling the TriggerHandle factory on the Application class
 to handle the given SObjectType and use a certain TriggerContext implementation.
```apex
trigger Accounts on Account   
        (after delete, after insert, after undelete, after update, 
                before delete, before insert, before update)
{
    // Invoke the handler
    Application.TriggerHandler.handle(
            Accounts.SObjectType,
            fflib_TriggerSObjectContext.class
    );
}
```

### Trigger Handlers types
There are three different handler types to support the triggers; 
- Standard SObject, 
- ChangeEvent,
- Platform Event.

#### SObject Trigger Handler
Extending a trigger handler from the `fflib_TriggerSObjectHandler` abstract class 
will give the handler a range of feature only available when handling SObjects.
The trigger context class is also more specific to only handling Standard and custom SObjects.

There are two ways to write the trigger handler, 
a pre and handle method can be used or the traditional methods like onBeforeInsert  
```apex
public with sharing class MyBusinessLogic extends fflib_TriggerSObjectHandler
{
    public override void pre(fflib_TriggerSObjectContext ctx) {}

    public override void handle(fflib_TriggerSObjectContext ctx)
    {
       // Add your logic here
    }
}
```
or
```apex
public with sharing class MyBusinessLogic extends fflib_TriggerSObjectHandler
{
    public override void onBeforeInsert(fflib_TriggerSObjectContext ctx) 
    {
       // Add your logic here
    }

    public override void onBeforeUpdate(fflib_TriggerSObjectContext ctx)
    {
       // Add your logic here
    }
}
```
```apex
trigger Accounts on Account   
        (after delete, after insert, after undelete, after update, 
                before delete, before insert, before update)
{
    // Invoke the handler
    Application.TriggerHandler.handle(
            Accounts.SObjectType,
            fflib_TriggerSObjectContext.class
    );
}
```

#### ChangeEvent Trigger Handler
Extending a trigger handler from the `fflib_TriggerChangeEventHandler` abstract class 
will give the handler a range of feature only available when handling Change Events. 
This can only be used when handling ChangeEvents not for any other trigger type.
```apex
public with sharing class MyBusinessLogic extends fflib_TriggerChangeEventHandler
{
    public override void pre(fflib_TriggerChangeEventContext ctx) {}

    public override void handle(fflib_TriggerChangeEventContext ctx)
    {
       // Add your logic here
    }
}
```
```apex
trigger AccountChangeEvents on AccountChangeEvent (after insert)
{
    // Invoke the handler
    Application.TriggerHandler.handle(
            AccountChangeEvent.SObjectType, 
            fflib_TriggerChangeEventContext.class);
}
```
#### PlatformEvent Trigger Handler
Extending a trigger handler from the `fflib_TriggerPlatformEventHandler` abstract class 
will give the handler a range of feature only available when handling Platform Events. 
This can only be used when handling Platform Events not for any other trigger type.
```apex
public with sharing class MyBusinessLogic extends fflib_TriggerPlatformEventHandler
{
    public override void pre(fflib_TriggerPlatformEventContext ctx) {}

    public override void handle(fflib_TriggerPlatformEventContext ctx)
    {
       // Add your logic here
    }
}
```
```apex
trigger AccountPlatformEvents on Account__e (after insert)
{
    // Invoke the handler
    Application.TriggerHandler.handle(
            AccountChangeEvent.SObjectType, 
            fflib_TriggerPlatformEventContext.class);
}
```

### Trigger Context
A trigger context provides extra features for a certain trigger type. 
It also contains data accessible and features used across all trigger handlers.

#### SObject trigger context
Features provided via the `fflib_TriggerSObjectContext` are:
- access to the features of the System.Trigger class  
- access to a domain class containing the records of the trigger operation
- easy listing of records with specific fields changed
- registering the interest in and returning related records  

 
#### Change Event trigger context
Features provided via the `fflib_TriggerChangeEventContext` are:
- easy access to records with certain fields changed

#### Platform Event trigger context
Features provided via the `fflib_TriggerPlatformEventContext` are:
- access to a domain class containing the records of the trigger operation

----

### Examples 

#### Conditional SObject Trigger
The following example invokes logic only when a certain condition is met.
In this case the logic is to always set the rating to 'Warm' for new accounts 
originating from 'Ireland' with more than 25 employees.
```apex
public with sharing class MyBusinessLogic extends fflib_TriggerSObjectHandler
{
    private Accounts largeIrishAccounts;

    public override void pre(fflib_TriggerSObjectContext ctx) 
    {
        if (!isValidTriggerOperation(ctx)) return;
 
        largeIrishAccounts = 
            ctx.getDomain()
                    .selectByCountry('Ireland')
                    .selectByNumberOfEmployeesGreaterThan(25);
    }

    public override void handle(fflib_TriggerSObjectContext ctx)
    {
        // Guard clause with validation
        if (!isValidExecution(ctx)) return ;  
        
        largeIrishAccounts.setRating('Warm');
    }

    private Boolean isValidTriggerOperation(fflib_TriggerSObjectContext ctx)
    {
        return (ctx.operationType == System.TriggerOperation.BEFORE_INSERT || 
                ctx.operationType == System.TriggerOperation.BEFORE_UPDATE );
    }
    
    private Boolean isValidExecution(fflib_TriggerSObjectContext ctx)
    {
        return largeIrishAccounts.isNotEmpty() && isValidTriggerOperation(ctx);
    }
}
```
In this example the `pre` method is used to perform the initial filter of the records, 
while the handle method is used perform the business logic if it is required.

This design is particular useful when the logic is the same for different trigger operation types.
 
#### Traditional Apex Enterprise Patterns SObject Trigger
The same example as shown in the previous one can be written using a similar way as the 
traditional triggerhandler of the Apex Enterprise Patterns.
This is very usefull when the logic is different for certain trigger operation types.

In this case the logic is to always set the rating to 'Warm' for new accounts 
originating from 'Ireland' with more than 25 employees. 
But when the account is updated, it must at least have a rating of 'Warm' or 'Hot'. 


```apex
public with sharing class MyBusinessLogic extends fflib_TriggerSObjectHandler
{
    private Accounts largeIrishAccounts;

    public override void onBeforeInsert(fflib_TriggerSObjectContext ctx) 
    {
        Accounts largeIrishAccounts = 
            ctx.getDomain()
                    .selectByCountry('Ireland')
                    .selectByNumberOfEmployeesGreaterThan(25);

        if (largeIrishAccounts.isEmpty()) return;  // Guard clause with validation

        largeIrishAccounts.setRating('Hot');
    }
    
    public override void onBeforeUpdate(fflib_TriggerSObjectContext ctx)
    {
        Accounts changedRating = ctx.getChangedRecords(Schema.Accounts.Rating);
        if (changedRating.isEmpty()) return;

        Accounts largeIrishAccounts = 
                changedRating.selectByCountry('Ireland')
                        .selectByNumberOfEmployeesGreaterThan(25);
        if (largeIrishAccounts.isEmpty()) return;

        largeIrishAccounts.selectByRating(new Set<String>{ null, '', 'Cold'})
                .addError(Label.AccountRatingMustBeAtLeastWarm);
    }
}
```

#### Trigger requiring input from related records
This next example shows a handler that requires input from related records.

In this case the logic is to always set the rating to 'Warm' for accounts with contacts
originating from 'Ireland' with more than 25 employees.
When the they are without contacts, the rating will always default back to 'Cold'.
```apex
public with sharing class MyBusinessLogic extends fflib_TriggerSObjectHandler
{
    private Accounts largeIrishAccounts;

    public override void pre(fflib_TriggerSObjectContext ctx) 
    {
        if (!isValidTriggerOperation(ctx)) return; 

        largeIrishAccounts = 
            ctx.getDomain()
                    .selectByCountry('Ireland')
                    .selectByNumberOfEmployeesGreaterThan(25);
        
        if (largeIrishAccounts.isEmpty()) return;
        
        // Here we register the interest in related accounts, 
        // the ctx will fetch them for us and have them available 
        // when the handle method is invoked
        ctx.addRelatedRecords(Schema.Account.Contacts);
    }

    public override void handle(fflib_TriggerSObjectContext ctx)
    {
        if (!isValidExecution(ctx)) return;  
        
        // Here we get the related records of all the records processed by the trigger 
        Map<Id, Contacts> contactsByAccountId = 
                ctx.getRelated(Schema.Account.Contacts)
                        .getMapByAccountIds()
        
        Set<Id> largeIrishAccountIds = largeIrishAccounts.getRecordIds();
        Map<Id, String> ratingByAccountId = new Map<Id, String>();
        for (Id accountId  : largeIrishAccountIds) 
        {
            if (contactsByAccountId.containsKey(accountId))  
            {
                ratingByAccountId.put(accountId, 'Cold');
            }  
            else
            {
                ratingByAccountId.put(accountId, 'Warm');
            }
        }
        largeIrishAccounts.setRating(ratingByAccountId);
    }

    private Boolean isValidTriggerOperation(fflib_TriggerSObjectContext ctx)
    {
        return (ctx.operationType == System.TriggerOperation.BEFORE_INSERT || 
                ctx.operationType == System.TriggerOperation.BEFORE_UPDATE );
    }
    
    private Boolean isValidExecution(fflib_TriggerSObjectContext ctx)
    {
        return largeIrishAccounts.isNotEmpty() && isValidTriggerOperation(ctx);
    }
}
```
In this example the `addRelatedRecords` method is called in the `pre` method to register 
its interest in the related Contact records of these accounts.
Once all the pre steps are performed for all the handlers,
the related records are fetched from the database by the Trigger Content (ctx) 
and passed to the `handler` method.

#### Trigger listening to changed fields
 
##### Perform logic on the changed record
This example listens to changes on certain fields and only then perform its logic
within the scope of the records processed by the trigger.
```apex
trigger Accounts on Account   
        (after delete, after insert, after undelete, after update, before delete, before insert, before update)
{
    Application.TriggerHandler.handle(Accounts.SObjectType, fflib_TriggerSObjectContext.class );
}
```
```apex
public with sharing class MyBusinessLogic extends fflib_TriggerSObjectHandler
{
    public override void onBeforeUpdate(fflib_TriggerSObjectContext ctx)
    {
        // Get the records with a changed value for the Account.Name field
        Accounts changedRecords = ctx.getChanged(Schema.Account.Name);
    
        // Prevent further execution if there are no records with a changed Account.Name field
        if (changedRecords.isEmpty()) return;  
        
        // Perform the logic on only those records with a changed Account.Name field
        changedRecords.upperCaseName();
    }

    public override void onBeforeInsert(fflib_TriggerSObjectContext ctx)
    {
        // Just upper case the name field for all new records    
        ((Accounts) ctx.getDomain())
                .upperCaseName();
    }
}
```
```apex
public with sharing class Accounts extends fflib_SObjectDomain
{
    ...
    public void upperCaseName()
    {
        for (Account record : (List<Account>) Records) 
        {
            record.Name = record.Name.toUpperCase();
        }
    }   
    ...
}
```
 
##### Perform logic outside the scope of the changed record 
This example listens to changes on certain fields and only then perform its logic
on records not part of the records processed by the trigger.
```apex
trigger AccountChangeEvents on AccountChangeEvent (after insert)
{
    Application.TriggerHandler.handle(AccountChangeEvent.SObjectType, fflib_TriggerChangeEventContext.class);
}
```
```apex
public with sharing class MyBusinessLogic extends fflib_TriggerChangeEventHandler
{
    public override void handle(fflib_TriggerChangeEventContext ctx)
    {
        if (!isValidExecution(ctx)) return;  

        ((AccountContactsService) Application.Service.newInstance(AccountContactsService.class))
                .copyShippingCountryToRelatedContacts(
                        ctx.getRecordIds()
        );       
    }

    private Boolean isValidExecution(fflib_TriggerChangeEventContext ctx)
    {
        return ctx.operationType == 'UPDATE' && ctx.hasChangedField(Schema.Account.ShippingCountry);
    }
}
```
