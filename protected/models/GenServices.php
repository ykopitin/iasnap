<?php

/**
 * This is the model class for table "gen_services".
 *
 * The followings are the available columns in table 'gen_services':
 * @property integer $id
 * @property string $name
 * @property integer $subjnap_id
 * @property string $regulations
 * @property string $reason
 * @property string $submission_proc
 * @property string $docums
 * @property integer $is_payed
 * @property string $payed_regulations
 * @property string $payed_rate
 * @property string $bank_info
 * @property string $deadline
 * @property string $denail_grounds
 * @property string $result
 * @property string $answer
 * @property string $is_online
 *
 * The followings are the available model relations:
 * @property CabPromotingBids[] $cabPromotingBids
 * @property GenServCatClass[] $genServCatClasses
 * @property GenServDocum[] $genServDocums
 * @property GenServRegulations[] $genServRegulations
 * @property GenAuthorities $subjnap
 */
class GenServices extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'gen_services';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('name, subjnap_id, regulations, reason, submission_proc, docums, is_payed, deadline, result, answer, is_online', 'required'),
			array('subjnap_id, is_payed', 'numerical', 'integerOnly'=>true),
			array('name', 'length', 'max'=>255),
			array('is_online', 'length', 'max'=>6),
			array('payed_regulations, payed_rate, bank_info, denail_grounds', 'safe'),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, name, subjnap_id, regulations, reason, submission_proc, docums, is_payed, payed_regulations, payed_rate, bank_info, deadline, denail_grounds, result, answer, is_online', 'safe', 'on'=>'search'),
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
			'cabPromotingBids' => array(self::HAS_MANY, 'CabPromotingBids', 'services_id'),
			'genServCatClasses' => array(self::HAS_MANY, 'GenServCatClass', 'service_id'),
			'genServDocums' => array(self::HAS_MANY, 'GenServDocum', 'service_id'),
			'genServRegulations' => array(self::HAS_MANY, 'GenServRegulations', 'service_id'),
			'subjnap' => array(self::BELONGS_TO, 'GenAuthorities', 'subjnap_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'name' => 'Name',
			'subjnap_id' => 'Subjnap',
			'regulations' => 'Regulations',
			'reason' => 'Reason',
			'submission_proc' => 'Submission Proc',
			'docums' => 'Docums',
			'is_payed' => 'Is Payed',
			'payed_regulations' => 'Payed Regulations',
			'payed_rate' => 'Payed Rate',
			'bank_info' => 'Bank Info',
			'deadline' => 'Deadline',
			'denail_grounds' => 'Denail Grounds',
			'result' => 'Result',
			'answer' => 'Answer',
			'is_online' => 'Is Online',
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
		$criteria->compare('name',$this->name,true);
		$criteria->compare('subjnap_id',$this->subjnap_id);
		$criteria->compare('regulations',$this->regulations,true);
		$criteria->compare('reason',$this->reason,true);
		$criteria->compare('submission_proc',$this->submission_proc,true);
		$criteria->compare('docums',$this->docums,true);
		$criteria->compare('is_payed',$this->is_payed);
		$criteria->compare('payed_regulations',$this->payed_regulations,true);
		$criteria->compare('payed_rate',$this->payed_rate,true);
		$criteria->compare('bank_info',$this->bank_info,true);
		$criteria->compare('deadline',$this->deadline,true);
		$criteria->compare('denail_grounds',$this->denail_grounds,true);
		$criteria->compare('result',$this->result,true);
		$criteria->compare('answer',$this->answer,true);
		$criteria->compare('is_online',$this->is_online,true);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return GenServices the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
    
    
    
    
    
    
    
    
    
    
    
    
     public function getService($id) {
         
    /*   $rows=$this->findAllByPk($id);      
       $name=array();
         foreach($rows as $row) {
            $name[]=$row['name'];
           // $Orgid[]=$row['id'];
                      }    */
        $name=$this->findAllByPk($id)->name;              
                                
         return $name;}
    
    
    
    
}
