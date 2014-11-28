<?php

/**
 * This is the model class for table "ff_document_cnap".
 *
 * The followings are the available columns in table 'ff_document_cnap':
 * @property integer $id
 * @property integer $registry
 * @property integer $storage
 * @property string $createdate
 * @property integer $route
 * @property integer $available_nodes
 * @property integer $available_actions
 * @property string $regnum
 * @property string $regdate
 * @property integer $legal_personality
 * @property integer $organization
 * @property string $person_name
 * @property string $person_drfo
 * @property string $address
 * @property string $phone1
 * @property string $phone2
 * @property integer $delivery_reply
 * @property string $email
 * @property integer $service
 * @property string $context
 * @property string $reason
 * @property integer $reply
 * @property string $file_petition
 * @property string $file_petition_fileedsname
 * @property string $plandate
 * @property string $factdate
 * @property integer $administrator
 * @property integer $executor
 * @property string $file_result
 * @property string $file_result_fileedsname
 */
class FfDocumentCnap extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'ff_document_cnap';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('id, createdate', 'required'),
			array('id, registry, storage, route, available_nodes, available_actions, legal_personality, organization, delivery_reply, service, reply, administrator, executor', 'numerical', 'integerOnly'=>true),
			array('regnum, person_name, person_drfo, file_petition_fileedsname, file_result_fileedsname', 'length', 'max'=>255),
			array('phone1, phone2', 'length', 'max'=>20),
			array('email', 'length', 'max'=>70),
			array('regdate, address, context, reason, file_petition, plandate, factdate, file_result', 'safe'),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, registry, storage, createdate, route, available_nodes, available_actions, regnum, regdate, legal_personality, organization, person_name, person_drfo, address, phone1, phone2, delivery_reply, email, service, context, reason, reply, file_petition, file_petition_fileedsname, plandate, factdate, administrator, executor, file_result, file_result_fileedsname', 'safe', 'on'=>'search'),
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
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'registry' => 'Registry',
			'storage' => 'Storage',
			'createdate' => 'Createdate',
			'route' => 'Route',
			'available_nodes' => 'Available Nodes',
			'available_actions' => 'Available Actions',
			'regnum' => 'Regnum',
			'regdate' => 'Regdate',
			'legal_personality' => 'Legal Personality',
			'organization' => 'Organization',
			'person_name' => 'Person Name',
			'person_drfo' => 'Person Drfo',
			'address' => 'Address',
			'phone1' => 'Phone1',
			'phone2' => 'Phone2',
			'delivery_reply' => 'Delivery Reply',
			'email' => 'Email',
			'service' => 'Service',
			'context' => 'Context',
			'reason' => 'Reason',
			'reply' => 'Reply',
			'file_petition' => 'File Petition',
			'file_petition_fileedsname' => 'File Petition Fileedsname',
			'plandate' => 'Plandate',
			'factdate' => 'Factdate',
			'administrator' => 'Administrator',
			'executor' => 'Executor',
			'file_result' => 'File Result',
			'file_result_fileedsname' => 'File Result Fileedsname',
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
	public function search()
	{
		// @todo Please modify the following code to remove attributes that should not be searched.

		$criteria=new CDbCriteria;

		$criteria->compare('id',$this->id);
		$criteria->compare('registry',$this->registry);
		$criteria->compare('storage',$this->storage);
		$criteria->compare('createdate',$this->createdate,true);
		$criteria->compare('route',$this->route);
		$criteria->compare('available_nodes',$this->available_nodes);
		$criteria->compare('available_actions',$this->available_actions);
		$criteria->compare('regnum',$this->regnum,true);
		$criteria->compare('regdate',$this->regdate,true);
		$criteria->compare('legal_personality',$this->legal_personality);
		$criteria->compare('organization',$this->organization);
		$criteria->compare('person_name',$this->person_name,true);
		$criteria->compare('person_drfo',$this->person_drfo,true);
		$criteria->compare('address',$this->address,true);
		$criteria->compare('phone1',$this->phone1,true);
		$criteria->compare('phone2',$this->phone2,true);
		$criteria->compare('delivery_reply',$this->delivery_reply);
		$criteria->compare('email',$this->email,true);
		$criteria->compare('service',$this->service);
		$criteria->compare('context',$this->context,true);
		$criteria->compare('reason',$this->reason,true);
		$criteria->compare('reply',$this->reply);
		$criteria->compare('file_petition',$this->file_petition,true);
		$criteria->compare('file_petition_fileedsname',$this->file_petition_fileedsname,true);
		$criteria->compare('plandate',$this->plandate,true);
		$criteria->compare('factdate',$this->factdate,true);
		$criteria->compare('administrator',$this->administrator);
		$criteria->compare('executor',$this->executor);
		$criteria->compare('file_result',$this->file_result,true);
		$criteria->compare('file_result_fileedsname',$this->file_result_fileedsname,true);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return FfDocumentCnap the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
