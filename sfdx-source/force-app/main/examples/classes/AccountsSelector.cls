/**
 * File Name: AccountsSelector 
 * Description:
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public abstract inherited sharing class AccountsSelector extends fflib_SObjectSelector
{
	public List<Schema.SObjectField> getSObjectFieldList()
	{
		return new List<Schema.SObjectField>
		{
				Account.Id,
				Account.Rating,
				Account.ShippingCountry
		};
	}

	public Schema.SObjectType getSObjectType()
	{
		return Account.SObjectType;
	}

	public List<Account> selectById(Set<Id> idSet)
	{
		return (List<Account>) selectSObjectsById(idSet);
	}
}