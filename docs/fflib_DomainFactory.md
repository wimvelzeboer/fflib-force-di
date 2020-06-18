# fflib-force-di

## fflib Domain Factory

Interface for the Domain factory to be able to dynamically instantiate domains

### Method reference

 - [newInstance](#newinstance)
 <br/>Constructs a new domain instance for the query result
 - [replaceWith](#replacewith)
 <br/>Dynamically replace a domain implementation at runtime
 - [setMock](#setmock)
 <br/>Replace the implementation with a mock version

#### newInstance
```apex
fflib_ISObjectDomain newInstance(Set<Id> recordIds);
fflib_ISObjectDomain newInstance(List<SObject> records);
fflib_ISObjectDomain newInstance(List<SObject> records, SObjectType domainSObjectType);	
```
Constructs a new domain instance for the query result
###### Examples
Create an instance of the accounts domain with account ids
```apex
Accounts accounts = (Accounts) Application.Domain.newInstance(idSet);
```
A domain created with Account records
```apex
List<Account> records = new List<Account> { ... }
Accounts accounts = (Accounts) Application.Domain.newInstance(records);
```
To create a accounts domain with SObjects
```apex
List<SObject> records = new List<SObject> { ... }
Accounts accounts = (Accounts) Application.Domain.newInstance(records, Schema.Account.SObjectType);
```
#### replaceWith
```apex
void replaceWith(SObjectType sObjectType, Object domainImpl);
```
Dynamically replace a domain implementation at runtime

###### Example
We have one domain interface class
```apex
public interface Accounts extends fflib_ISObjectDomain
{
    void setDefaults();
}
```
And two implementations, one default and one specific for Holland
```apex
public class AccountsImp extends fflib_ISObjectDomain implements Accounts 
{
    public void setDefaults()
    {
        setStringFieldValue(Schema.Account.Name, 'Global Account');
    }
}
public class AccountsHollandImp extends fflib_ISObjectDomain implements Accounts 
{
    public void setDefaults()
    {
        setStringFieldValue(Schema.Account.Name, 'Orange Account');
    }
}
```
An A-B test can be done where only the users from Holland get a different implementation.
In the example below the implementation is being replaced for all users from Holland. 
The business logic executed by this trigger will all use the replaced implementation. 
```apex
trigger JJ_Account on Account (before insert, before update)
{
    User currentUser = [SELECT Id, Country FROM User WHERE Id = :UserInfo.getUserId()];
    if (currentUser.Country == 'Holland')
    {
        Application.Domain.replaceWith(Schema.Account.SObjectType, AccountsHollandImp.class);
    }
    Application.TriggerHandler.handle(Accounts.SObjectType);
}
```

#### setMock
```apex
void setMock(Schema.SObjectType sObjectType, Object domainImp);
```
Replace the implementation with a mock version
###### Example
```apex
@IsTest
static void itShouldRunMyTest()
{
    // GIVEN
    fflib_ApexMocks mocks = new fflib_ApexMocks();
    Accounts domainMock = (Accounts) mocks.mock(AccountsImp.class);
    Application.Domain.setMock(Schema.Account.SObjectType, domainMock);
}
```
