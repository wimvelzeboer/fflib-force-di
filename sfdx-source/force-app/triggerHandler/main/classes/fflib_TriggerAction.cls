/**
 * File Name: fflib_TriggerAction
 * Description: Interface for trigger actions containing the business logic
 * @author : architect ir. Wilhelmus G.J. Velzeboer
 */
public interface fflib_TriggerAction
{
	/**
	 * The pre function enables the handler to perform checks prior to execution.
	 * It can be used to perform logic that initialises data useful for all handlers
	 *
	 * @param ctx Instance of fflib_TriggerContext providing access to the Trigger Context like System.Trigger
	 */
	void pre(fflib_TriggerContext ctx);

	/**
	 * Runs the logic of the trigger action
	 * @param ctx Instance of fflib_TriggerContext providing access to the Trigger Context like System.Trigger
	 */
	void run(fflib_TriggerContext ctx);
}