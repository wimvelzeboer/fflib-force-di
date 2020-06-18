/**
 * File Name: fflib_TriggerSObjectHandler 
 * Description: Abstract Trigger Action for handling business logic triggered by SObjects DML Operations
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public abstract with sharing class fflib_TriggerActionSObject implements fflib_TriggerAction
{
	/**
	 * Class constructor
	 */
	public fflib_TriggerActionSObject(){}


	public void run(fflib_TriggerContext ctx)
	{
		run((fflib_TriggerContextSObject) ctx);
	}

	public virtual void run(fflib_TriggerContextSObject ctx)
	{
		switch on ctx.getOperationType() {
			when BEFORE_INSERT { handleBeforeInsert(ctx); }
			when BEFORE_UPDATE { handleBeforeUpdate(ctx); }
			when BEFORE_DELETE { handleBeforeDelete(ctx); }
			when AFTER_INSERT { handleAfterInsert(ctx); }
			when AFTER_UPDATE { handleAfterUpdate(ctx); }
			when AFTER_DELETE { handleAfterDelete(ctx); }
			when AFTER_UNDELETE { handleAfterUnDelete(ctx); }
			when else
			{
				throw new TriggerActionSObjectException(
					String.format(
							// Todo - migrate to label
							'Unknown trigger operationType: {0}',
							new List<String>
							{
								String.valueOf(ctx.getOperationType())
							}
					)
				);
			}
		}
	}


	/**
	 * Base handler for the Apex Trigger event Before Insert, calls the onApplyDefaults method, followed by onBeforeInsert
	 **/
	public virtual void handleBeforeInsert(fflib_TriggerContextSObject ctx)
	{
		onApplyDefaults(ctx);
		onBeforeInsert(ctx);
	}

	/**
	 * Base handler for the Apex Trigger event Before Update, calls the onBeforeUpdate method
	 **/
	public virtual void handleBeforeUpdate(fflib_TriggerContextSObject ctx)
	{
		onBeforeUpdate(ctx);
	}

	/**
	 * Base handler for the Apex Trigger event Before Delete, calls the onBeforeDelete method
	 **/
	public virtual void handleBeforeDelete(fflib_TriggerContextSObject ctx)
	{
		onBeforeDelete(ctx);
	}

	/**
	 * Base handler for the Apex Trigger event After Insert, checks object security and calls the onValidate and onAfterInsert methods
	 *
	 * @throws DomainException if the current user context is not able to create records
	 **/
	public virtual void handleAfterInsert(fflib_TriggerContextSObject ctx)
	{
//		todo - add CRUD security check
//		if(Configuration.EnforcingTriggerCRUDSecurity && !SObjectDescribe.isCreateable())
//			throw new DomainException('Permission to create an ' + SObjectDescribe.getName() + ' denied.');

		onValidate(ctx);
		onAfterInsert(ctx);
	}

	/**
	 * Base handler for the Apex Trigger event After Update, checks object security and calls the onValidate, onValidate(Map<Id,SObject>) and onAfterUpdate methods
	 *
	 * @throws DomainException if the current user context is not able to update records
	 **/
	public virtual void handleAfterUpdate(fflib_TriggerContextSObject ctx)
	{
//		todo - add CRUD security check
//		if(Configuration.EnforcingTriggerCRUDSecurity && !SObjectDescribe.isUpdateable())
//			throw new DomainException('Permission to update an ' + SObjectDescribe.getName() + ' denied.');
//
//		if(Configuration.OldOnUpdateValidateBehaviour)
//			onValidate();
		onValidate(ctx);
		onAfterUpdate(ctx);
	}

	/**
	 * Base handler for the Apex Trigger event After Delete, checks object security and calls the onAfterDelete method
	 *
	 * @throws DomainException if the current user context is not able to delete records
	 **/
	public virtual void handleAfterDelete(fflib_TriggerContextSObject ctx)
	{
//		todo - add CRUD security check
//		if(Configuration.EnforcingTriggerCRUDSecurity && !SObjectDescribe.isDeletable())
//			throw new DomainException('Permission to delete an ' + SObjectDescribe.getName() + ' denied.');

		onAfterDelete(ctx);
	}

	/**
	 * Base handler for the Apex Trigger event After Undelete, checks object security and calls the onAfterUndelete method
	 *
	 * @throws DomainException if the current user context is not able to delete records
	 **/
	public virtual void handleAfterUndelete(fflib_TriggerContextSObject ctx)
	{
//		todo - add CRUD security check
//		if(Configuration.EnforcingTriggerCRUDSecurity && !SObjectDescribe.isCreateable())
//			throw new DomainException('Permission to create an ' + SObjectDescribe.getName() + ' denied.');

		onAfterUndelete(ctx);
	}

	/**
	 * Override this to apply defaults to the records, this is called by the handleBeforeInsert method
	 **/
	public virtual void onApplyDefaults(fflib_TriggerContextSObject ctx) { }

	/**
	 * Override this to apply general validation to be performed during insert or update, called by the handleAfterInsert and handleAfterUpdate methods
	 **/
	public virtual void onValidate(fflib_TriggerContextSObject ctx) {	}

	/**
	 * Override this to perform processing during the before insert phase, this is called by the handleBeforeInsert method
	 **/
	public virtual void onBeforeInsert(fflib_TriggerContextSObject ctx) { }

	/**
	 * Override this to perform processing during the before update phase, this is called by the handleBeforeUpdate method
	 **/
	public virtual void onBeforeUpdate(fflib_TriggerContextSObject ctxs) { }

	/**
	 * Override this to perform processing during the before delete phase, this is called by the handleBeforeDelete method
	 **/
	public virtual void onBeforeDelete(fflib_TriggerContextSObject ctx) { }

	/**
	 * Override this to perform processing during the after insert phase, this is called by the handleAfterInsert method
	 **/
	public virtual void onAfterInsert(fflib_TriggerContextSObject ctx) { }

	/**
	 * Override this to perform processing during the after update phase, this is called by the handleAfterUpdate method
	 **/
	public virtual void onAfterUpdate(fflib_TriggerContextSObject ctx) { }

	/**
	 * Override this to perform processing during the after delete phase, this is called by the handleAfterDelete method
	 **/
	public virtual void onAfterDelete(fflib_TriggerContextSObject ctx) { }

	/**
	 * Override this to perform processing during the after undelete phase, this is called by the handleAfterDelete method
	 **/
	public virtual void onAfterUndelete(fflib_TriggerContextSObject ctx) { }


	public virtual void pre(fflib_TriggerContext ctx)
	{
		pre((fflib_TriggerContextSObject) ctx);
	}

	public virtual void pre(fflib_TriggerContextSObject ctx) {}

	public class TriggerActionSObjectException extends Exception {}
}