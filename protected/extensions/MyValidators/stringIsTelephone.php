class stringIsTelephone extends CValidator
{
 	//0XXYYYYYYY
	private $pattern = '/0[0-9]{2}\s?[0-9]{7}/s';

	/**
	 * Validates the attribute of the object.
	 * If there is any error, the error message is added to the object.
	 * @param CModel $object the object being validated
	 * @param string $attribute the attribute being validated
	 */
	protected function validateAttribute($object,$attribute)
	{
		// extract the attribute value from it's model object
    		$value=$object->$attribute;
		// Якщо набір символів у рядку не відповідає специфікації Base64
		if(!preg_match($pattern, $value))
		{
			$this->addError($object,$attribute,'Невірний формат номера телефону');
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
		$condition="!value.match({$pattern})";
 
		return "
if(".$condition.") {
    messages.push(".CJSON::encode('Невірний формат номера телефону').");
}
";
	}

}
