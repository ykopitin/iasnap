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
	 public $author_search;
	 public $author_search1;
	 public $idi;
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
			array('name, subjnap_id, subjwork_id, regulations, reason, submission_proc, docums, is_payed, deadline, result, answer, is_online,have_expertise,is_payed_expertise', 'required'),
			array('subjnap_id, subjwork_id, is_payed, have_expertise, is_payed_expertise', 'numerical', 'integerOnly'=>true),
		//	array('length', 'max'=>255),
			array('name','length','max'=>500),
			array('is_online', 'length', 'max'=>6),
			array('payed_regulations, payed_rate, bank_info, denail_grounds, nes_expertise, payed_expertise, regul_expertise, bank_info_expertise, rate_expertise', 'safe'),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, name, subjnap_id, subjwork_id,regulations, reason, submission_proc, docums, is_payed, payed_regulations, payed_rate, bank_info, deadline, denail_grounds, result, answer, is_online, nes_expertise, payed_expertise, regul_expertise, bank_info_expertise, rate_expertise', 'safe', 'on'=>'search'),
		    array('author_search', 'safe', 'on'=>'search'),
			array('author_search1', 'safe', 'on'=>'search'),
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
			'cabPromotingBids' => array(self::HAS_MANY, 'CabPromotingBids', 'services_id'),
			'genServCatClasses' => array(self::HAS_MANY, 'GenServCatClass', 'service_id'),
			'genServDocums' => array(self::HAS_MANY, 'GenServDocum', 'service_id'),
			'genServRegulations' => array(self::HAS_MANY, 'GenServRegulations', 'service_id'),
			'subjnap' => array(self::BELONGS_TO, 'GenAuthorities', 'subjnap_id'),
			'subjnapw' => array(self::BELONGS_TO, 'GenAuthorities', 'subjwork_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => '№ з/п',
			'name' => 'Назва послуги',
			'subjnap_id' => 'Місце подачі документів',
			'subjwork_id'=>'Виконавець',
			'regulations' => 'Нормативно-правові акти',
			'reason' => 'Підстава для отримання',
			'submission_proc' => 'Порядок подання',
			'docums' => 'Перелік документів',
			'is_payed' => 'Платність послуги',
			'payed_regulations' => 'Нормативно-правові акти',
			'payed_rate' => 'Розмір плати',
			'bank_info' => 'Банківські реквізити',
			'deadline' => 'Строк надання',
			'denail_grounds' => 'Підстави для відмови',
			'result' => 'Результат надання',
			'answer' => 'Способи отримання відповіді',
			'is_online' => 'Можливість надання в електронному вигляді',
			'have_expertise'=>'Необхідність проведення експертизи',
			'nes_expertise'=>'Необхідність експертизи',
			'is_payed_expertise'=>'Платність експертизи',
			'payed_expertise'=>'Платність експертизи інформація',
			'regul_expertise'=>'Акти законодавства експертиза',
			'rate_expertise'=>'Розмір плати за експертизу',
			'bank_info_expertise'=>'Банківські реквізити експертиза',
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		$criteria->with = array( 'subjnap', 'subjnapw' );
//        $criteria->with = array( 'subjnapw' );
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
		$criteria->compare('id',$this->id,true);
		$criteria->compare('t.name',$this->name,true);
		$criteria->compare('t.subjnap_id',$this->subjnap_id);
		$criteria->compare('t.subjwork_id',$this->subjwork_id);
		$criteria->compare('t.regulations',$this->regulations,true);
		$criteria->compare('t.reason',$this->reason,true);
		$criteria->compare('t.submission_proc',$this->submission_proc,true);
		$criteria->compare('t.docums',$this->docums,true);
		$criteria->compare('t.is_payed',$this->is_payed);
		$criteria->compare('t.payed_regulations',$this->payed_regulations,true);
		$criteria->compare('t.payed_rate',$this->payed_rate,true);
		$criteria->compare('t.bank_info',$this->bank_info,true);
		$criteria->compare('t.deadline',$this->deadline,true);
		$criteria->compare('t.denail_grounds',$this->denail_grounds,true);
		$criteria->compare('t.result',$this->result,true);
		$criteria->compare('t.answer',$this->answer,true);
		$criteria->compare('t.is_online',$this->is_online,true);
		$criteria->compare('t.have_expertise',$this->have_expertise,true);
		$criteria->compare('t.nes_expertise',$this->nes_expertise,true);
		$criteria->compare('t.is_payed_expertise',$this->is_payed_expertise,true);
		$criteria->compare('t.payed_expertise',$this->payed_expertise,true);
		$criteria->compare('t.regul_expertise',$this->regul_expertise,true);
		$criteria->compare('t.rate_expertise',$this->rate_expertise,true);
		$criteria->compare('t.bank_info_expertise',$this->bank_info_expertise,true);
//////////////////////////////////////////////////////////////////////////////////////		
		//$criteria->compare( 'subjnap.name', $this->author_search, true );
		//$criteria->compare( 'subjnapw.name', $this->author_search1, true );
		//$criteria->compare( 'genServices.id', $this->idi);
		$criteria->addSearchCondition('subjnap.name', $this->author_search);
		$criteria->addSearchCondition('subjnapw.name', $this->author_search1);
		$criteria->addSearchCondition('t.id', $this->idi);
//////////////////////////////////////////////////////////////////////////////////////////////

		///////////////////////////////
		
		
		
		
		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
			 'sort'=>array(
        'attributes'=>array(
           'idi'=>array(
                'asc'=>'t.id',
                'desc'=>'t.id DESC',
            ),
           'name'=>array(
                'asc'=>'t.name',
                'desc'=>'t.name DESC',
            ),
		   'author_search'=>array(
                'asc'=>'subjnap.name',
                'desc'=>'subjnap.name DESC',
            ),
			'author_search1'=>array(
                'asc'=>'subjnapw.name',
                'desc'=>'subjnapw.name DESC',
            ),
			'is_online'=>array(
                'asc'=>'t.is_online',
                'desc'=>'t.is_online DESC',
            ),
           ),
          ),

		));
	}

	public function search1()
	{
		// @todo Please modify the following code to remove attributes that should not be searched.

		$criteria=new CDbCriteria;

		$criteria->compare('id',$this->id);
		$criteria->compare('name',$this->name,true);
		$criteria->compare('subjnap_id',$this->subjnap_id);
		$criteria->compare('subjwork_id',$this->subjwork_id);
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
		$criteria->compare('have_expertise',$this->have_expertise,true);
		$criteria->compare('nes_expertise',$this->nes_expertise,true);
		$criteria->compare('is_payed_expertise',$this->is_payed_expertise,true);
		$criteria->compare('payed_expertise',$this->payed_expertise,true);
		$criteria->compare('regul_expertise',$this->regul_expertise,true);
		$criteria->compare('rate_expertise',$this->rate_expertise,true);
		$criteria->compare('bank_info_expertise',$this->bank_info_expertise,true);
		$criteria->alias = 'post';
		$criteria->join = 'INNER JOIN gen_authorities as user ON post.subjnap_id=user.id';
		$criteria->join = 'INNER JOIN gen_authorities as user1 ON post.subjwork_id=user1.id';
		$criteria->order = 'post.id';
		
		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
		
/*		$users=GenServices::model()->with(array(
        'genServices'=>array(
        'select'=>array('subjnap.id'),
        'joinType'=>'INNER JOIN',
        ),
        ))->findAll();
*/		
//		$users = GenServices::model()->findAllBySql("select u.`id` AS `id1`,u.`name` AS `name`,d.`name` AS `subjnap`,w.`name` AS `subjwork`, u.`is_online` AS `is_online` from gen_services u INNER JOIN gen_authorities d ON u.`subjnap_id`=d.`id` INNER JOIN gen_authorities w ON u.`subjwork_id`=w.`id`");
//
//	    return new CActiveDataProvider($this, array(
//        'data'=>$users,
//        ));
		
		
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
}
