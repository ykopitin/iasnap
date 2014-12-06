<?php

/**
 * UserIdentity represents the data needed to identity a user.
 * It contains the authentication method that checks if the provided
 * data can identity the user.
 */
class UserIdentity extends CUserIdentity
{
	/**
	 * Authenticates a user.
	 * The example implementation makes sure if the username and password
	 * are both 'demo'.
	 * In practical applications, this should be changed to authenticate
	 * against some persistent user identity storage (e.g. database).
	 * @return boolean whether authentication succeeds.
	 */
        private $_id;
        public function getId() {
            return $this->_id ;
        }

        public function authenticate()
	{
		$users=array(
			// username => password
			'demo'=>'demo',
			'admin'=>'admin',
                        'guestcnap'=>'1',
                        'guestcnap53'=>'1',
                        'admincnap'=>'1',
                        'execcnap'=>'1',
		);
		if(!isset($users[$this->username]))
			$this->errorCode=self::ERROR_USERNAME_INVALID;
		elseif($users[$this->username]!==$this->password)
			$this->errorCode=self::ERROR_PASSWORD_INVALID;
		else {
			$this->errorCode=self::ERROR_NONE;
                        switch ($this->username) {
                            case "guestcnap":
                            $this->_id=1;
                            break;
                            case "guestcnap53":
                            $this->_id=53;
                            break;
                            case "admincnap":
                            $this->_id=51;
                            break;
                            case "execcnap":
                            $this->_id=52;
                            break;                        
                        }
                }
		return !$this->errorCode;
	}
}