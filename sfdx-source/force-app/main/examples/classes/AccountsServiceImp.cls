/**
 * File Name: AccountsServiceImp 
 * Description: 
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public with sharing class AccountsServiceImp implements AccountsService
{
	@TestVisible
	private static final Set<String> HOT_COUNTRIES = new Set<String>
	{
			'South Africa',
			'Brazil'
	};

	@TestVisible
	private static final Set<String> COLD_COUNTRIES = new Set<String>
	{
			'Sweden',
			'Iceland',
			'Antarctica'
	};

	public void updateRating(Set<Id> ids)
	{
		updateRating(
				(Accounts) Application.Domain.newInstance(ids)
		);
	}

	public void updateRating(List<Account> records)
	{
		updateRating(
				(Accounts) Application.Domain.newInstance(records)
		);
	}

	public void updateRating(Accounts domain)
	{
		fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
		updateRating(unitOfWork, domain);
		unitOfWork.commitWork();
	}

	public void updateRating(fflib_ISObjectUnitOfWork unitOfWork, Accounts domain)
	{
		updateRatingCountries(unitOfWork, domain, COLD_COUNTRIES, 'Cold');
		updateRatingCountries(unitOfWork, domain, HOT_COUNTRIES, 'Hot');
	}

	private void updateRatingCountries(
			fflib_ISObjectUnitOfWork unitOfWork,
			Accounts domain,
			Set<String> countries,
			String rating
	)
	{
		List<Account> records = domain.getRecordsWithShippingCountries(countries);
		if (records.isEmpty())
		{
			return;
		}

		unitOfWork.registerDirty(
				((Accounts) Application.Domain.newInstance(records, Account.SObjectType))
						.setRating(rating)
						.getRecords()
		);
	}

}