/**
 * File Name: Accounts 
 * Description: 
 * Copyright (c) 2020 Johnson & Johnson
 * @author: architect ir. William G.J. Velzeboer | wvelzebo@its.jnj.com 
 */
public abstract inherited sharing class Accounts extends fflib_SObjectDomain
{
	public Accounts(List<SObject> sObjectList)
	{
		super(sObjectList);
	}

	public Accounts(List<SObject> sObjectList, SObjectType sObjectType)
	{
		super(sObjectList, sObjectType);
	}

	abstract public Accounts setRating(String rating);
	abstract public List<Account> getRecordsWithShippingCountries(Set<String> countries);
}