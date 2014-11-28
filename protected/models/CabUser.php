<?php

/**
 * This is the model class for table "cab_user_external".
 *
 * The followings are the available columns in table 'cab_user_external':
 * @property string $id
 * @property integer $type_of_user
 * @property string $email
 * @property string $phone
 * @property string $cab_state
 * @property string $authorities_id
 * @property string $str_activcode
 * @property int $time_activcode
 * @property mediumblob $pd_agreement_signed
 * @property int $time_registered
 * @property int $time_last_login
 *
 * The followings are the available model relations:
 * @property CabOrgExternalCerts[] $cabOrgExternalCerts
 * @property CabUserBidsConnect[] $cabUserBidsConnects
 * @property CabUserExternCerts[] $cabUserExternCerts
 */
class CabUser extends CActiveRecord
{
	public $author_search;
	public $user_rol;
	public $idi;
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'cab_user';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('fio, type_of_user, email, phone, cab_state, user_roles_id', 'required'),
//			array('type_of_user, email, phone', 'required'),
			array('type_of_user, authorities_id, user_roles_id', 'numerical', 'integerOnly'=>true),
			array('id', 'length', 'max'=>10),
			array('email', 'length', 'max'=>45),
			array('fio', 'length', 'max'=>250),
			array('email', 'email'),
			array('phone', 'length', 'max'=>12),
			array('cab_state', 'length', 'max'=>27),
			array('str_activcode', 'length', 'max'=>40),
			array('time_activcode, time_registered, time_last_login', 'numerical', 'integerOnly'=>true),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, type_of_user, fio, email, phone, cab_state, str_activcode, time_registered, time_last_login', 'safe', 'on'=>'search'),
		    array('author_search', 'safe', 'on'=>'search'),
			array('user_rol', 'safe', 'on'=>'search'),
			array('idi', 'safe', 'on'=>'search'),
		);
	}

	/**
	 * @return array relational rules.
	 */
	public function relations()
	{
		// NOTE: you may need to adjust the relation name and the related
		// class name for the relations automatically generated below.
		return array(
			'cabOrgExternalCerts' => array(self::HAS_MANY, 'CabOrgExternalCerts', 'ext_user_id'),
			'cabUserBidsConnects' => array(self::HAS_MANY, 'CabUserBidsConnect', 'user_id'),
			'cabUserExternCerts' => array(self::HAS_MANY, 'CabUserExternCerts', 'ext_user_id'),
			'cabUserAuthorityId' => array(self::BELONGS_TO, 'GenAuthorities', 'authorities_id'),
			'cabUserRole' => array(self::BELONGS_TO, 'CabUserRoles', 'user_roles_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'type_of_user' => 'Тип особи', // (0-фіз.особа, 1- ФОП, 2-юр.особа),
			'fio' => 'ПІБ або найменування',
			'email' => 'Електронна поштова скринька',
			'phone' => 'Номер телефону',
			'cab_state' => 'Стан кабінету',
			'organization' => 'Організація',
			'authorities_id' => 'ID місця надання послуг',
			'user_roles_id' => 'Роль користувача (0-адм.безп., 1-сист.адм., 2-адм.ЦНАП, 3-оп.НАП, 4-суб.зверн.)',
			'str_activcode' => 'Дані для тимчасового використання при реєстрації (строка активації користувача та ін.)',
			'time_activcode' => 'Час дії строки активації',
			'time_registered' => 'Дата реєстрації користувача',
			'time_last_login' => 'Дата останнього входу користувача',
		);
	}

	/**
	 * Retrieves a list of models based on the current search/filter conditions.
	 *
	 * Typical usecase:
	 * - Initialize the model fields with values from filter form.
	 * - Execute this method to get CActiveDataProvider instance which will filter
	 * models according to data in model fields.
	 * - Pass data provider to CGridView, CListView or any similar widget.
	 *
	 * @return CActiveDataProvider the data provider that can return the models
	 * based on the search/filter conditions.
	 */
	public function searchext()
	{
		// @todo Please modify the following code to remove attributes that should not be searched.

		$criteria=new CDbCriteria;

		$criteria->compare('id',$this->id,true);
		$criteria->compare('type_of_user',$this->type_of_user);
		$criteria->compare('fio',$this->fio,true);
		$criteria->compare('email',$this->email,true);
		$criteria->compare('phone',$this->phone,true);
		$criteria->compare('cab_state',$this->cab_state,true);
		$criteria->compare('authorities_id',$this->authorities_id,true);
//		$criteria->compare('user_roles_id',$this->user_roles_id,true);
		$criteria->compare('user_roles_id','4',true);
		$criteria->compare('str_activcode',$this->str_activcode,true);
		$criteria->compare('time_activcode',$this->time_activcode,true);
		$criteria->compare('time_registered',$this->time_registered,true);
		$criteria->compare('time_last_login',$this->time_last_login,true);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	public function searchint()
	{
		// @todo Please modify the following code to remove attributes that should not be searched.

		$criteria=new CDbCriteria;
		$criteria->with = array( 'cabUserRole', 'cabUserAuthorityId' );
		$criteria->compare('id',$this->id,true);
		$criteria->compare('type_of_user',$this->type_of_user);
		$criteria->compare('fio',$this->fio,true);
		$criteria->compare('email',$this->email,true);
		$criteria->compare('phone',$this->phone,true);
		$criteria->compare('cab_state',$this->cab_state,true);
		$criteria->compare('authorities_id',$this->authorities_id,true);
//		$criteria->compare('user_roles_id',$this->user_roles_id,true);
		$criteria->compare('user_roles_id','<4',true);
		$criteria->compare('str_activcode',$this->str_activcode,true);
		$criteria->compare('time_activcode',$this->time_activcode,true);
		$criteria->compare('time_registered',$this->time_registered,true);
		$criteria->compare('time_last_login',$this->time_last_login,true);
		$criteria->addSearchCondition('cabUserRole.user_role', $this->user_rol);
		$criteria->addSearchCondition('cabUserAuthorityId.name', $this->author_search);
		$criteria->addSearchCondition('t.id', $this->idi);
//		$criteria->alias = 'post';
//		$criteria->join = 'INNER JOIN gen_authorities as user ON post.authorities_id=user.id';
//		$criteria->join = 'INNER JOIN cab_user_roles as role ON post.user_roles_id=role.id';
//		$criteria->order = 'post.id';
		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
			
			 'sort'=>array(
        'attributes'=>array(
           'idi'=>array(
                'asc'=>'t.id',
                'desc'=>'t.id DESC',
            ),
			'fio'=>array(
                'asc'=>'t.fio',
                'desc'=>'t.fio DESC',
            ),
//			'type_of_user'=>array(
//                'asc'=>'t.type_of_user',
//                'desc'=>'t.type_or_user DESC',
//            ),
			'cab_state'=>array(
                'asc'=>'t.cab_state',
                'desc'=>'t.cab_state DESC',
            ),
		   'user_rol'=>array(
                'asc'=>'cabUserRole.user_role',
                'desc'=>'cabUserRole.user_role DESC',
            ),
		   'author_search'=>array(
                'asc'=>'cabUserAuthorityId.name',
                'desc'=>'cabUserAuthorityId.name DESC',
            ),
		   'TimeLastLoginStr'=>array(
                'asc'=>'t.time_last_login',
                'desc'=>'t.time_last_login DESC',
            ),
			
			),
          ),			
		));
	}
	
	protected function afterSave()
    {
        $auth = Yii::app()->authManager;
        
        // revoke all auth items assigned to the user
        $items = $auth->getRoles($this->id);
        foreach ($items as $item) {
            $auth->revoke($item->name, $this->id);
        }
//	0	secadmin
//	1	siteadmin
//	2	cnapadmin
//	3	snapoperator
//	4	customer
//	5	guest
		
        // assign new role to the user
		if ($this->cab_state == "активований") {
			if ($this->user_roles_id <= 1) {
				$auth->assign('siteadmin', $this->id);
			} else
			if ($this->user_roles_id == 4) {
				$auth->assign('customer', $this->id);
			} else
				$auth->assign('guest', $this->id);
		}
		$auth->save();

        parent::afterSave();
    }	
	
	public function getTimeRegisteredStr(){
		if(isset($this->time_registered)&&($this->time_registered !== null)){
			return date('d.m.Y H:i:s', $this->time_registered);
		} else return null;
	}

	public function getTimeLastLoginStr(){
		if(isset($this->time_last_login)&&($this->time_last_login !== null)){
			return date('d.m.Y H:i:s', $this->time_last_login);
		} else return null;
	}
	
	public function getTimeActivCodeStr(){
		if(isset($this->time_activcode)&&($this->time_activcode !== null)&&($this->time_activcode > 1416131542)){
			return date('d.m.Y H:i:s', $this->time_activcode);
		} else return "Активація не потрібна";
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return CabUserExternal the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
