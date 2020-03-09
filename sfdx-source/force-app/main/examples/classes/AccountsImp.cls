/**
 * File Name: AccountsImp 
 * Description: 
 * Copyright (c) 2020 Johnson & Johnson
 * @author: architect ir. William G.J. Velzeboer | wvelzebo@its.jnj.com 
 */
public with sharing class AccountsImp extends Accounts
{
	public AccountsImp(List<Account> records)
	{
		super(records, Account.SObjectType);
	}

	public AccountsImp(List<Account> records, Schema.SObjectType sObjectType)
	{
		super(records, sObjectType);
	}

	public override Accounts setRating(String rating)
	{
		for (SObject record : Records)
		{
			record.put(Account.Rating, rating);
		}
		return (Accounts) this;
	}

	public override List<Account> getRecordsWithShippingCountries(Set<String> countries)
	{
		List<SObject> result = new List<SObject>();
		for (SObject record : Records)
		{
			if (countries.contains((String) record.get(Account.ShippingCountry)))
			{
				result.add(record);
			}
		}

		return result;
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable2
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new AccountsImp(sObjectList, Account.SObjectType);
		}

		public fflib_SObjectDomain construct(List<SObject> sObjectList, SObjectType sObjectType)
		{
			return new AccountsImp(sObjectList, sObjectType);
		}
	}
}