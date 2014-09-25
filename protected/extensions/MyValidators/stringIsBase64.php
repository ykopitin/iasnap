<?php
class stringIsBase64 extends CValidator
{
 
	private $pattern = '/^[a-zA-Z0-9\/\r\n+]*={0,2}$/';

	/**
	 * Validates the attribute of the object.
	 * If there is any error, the error message is added to the object.
	 * @param CModel $object the object being validated
	 * @param string $attribute the attribute being validated
	 */
	protected function validateAttribute($object,$attribute)
	{
		$pattern = $this->pattern;
		// extract the attribute value from it's model object
    		$value=$object->$attribute;
		// Якщо набір символів у рядку не відповідає специфікації Base64
		if(!preg_match($pattern, $value))
		{
			$this->addError($object,$attribute,'Помилка у перетворенні вхідних даних');
		}
	}

	/**
	 * Returns the JavaScript needed for performing client-side validation.
	 * @param CModel $object the data object being validated
	 * @param string $attribute the name of the attribute to be validated.
	 * @return string the client-side validation script.
	 * @see CActiveForm::enableClientValidation
	 */
	public function clientValidateAttribute($object,$attribute)
	{
		$pattern = $this->pattern;
		$condition="!value.match({$pattern})";
 
		return "
if(".$condition.") {
    messages.push(".CJSON::encode('Помилка у перетворенні вхідних даних').");
}
";
	}

}
?>
