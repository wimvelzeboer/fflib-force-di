/**
 * File Name: AccountsService 
 * Description:
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public interface AccountsService
{
	void updateRating(Set<Id> ids);
	void updateRating(List<Account> records);
	void updateRating(Accounts domain);
	void updateRating(fflib_ISObjectUnitOfWork unitOfWork, Accounts domain);
}