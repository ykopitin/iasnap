<?php 
class LogDb extends CDbLogRoute
{
 
    protected function createLogTable($db,$tableName)
    {
        $db->createCommand()->createTable($tableName, array(
            'id'=>'pk',
            'level'=>'varchar(128)',
            'category'=>'varchar(128)',
            'logtime'=>'int(11)', 
            'user_ip'=>'varchar(50)', //For IP 
            'user_id'=>'int(10)',
			'user_fio'=>'varchar(100)',
            'request_URL'=>'text',
            'message'=>'text',
        ));
    }
    protected function processLogs($logs)
    {
        $command=$this->getDbConnection()->createCommand();
        $logTime=time(); //date('Y.m.d H:i:s'); //Get Current Date
 
        foreach($logs as $log)
        {
			if(isset(Yii::app()->user->id)) {
				$i = Yii::app()->user->id;
				if(is_numeric($i) && ($i > 0)){
					$userid = $i;
					$us = CabUser::model()->findByPk($i);
					if ($us !== null) {
						$userfio = $us->fio;
					} else
						$userfio = "";
				} else {
					$userid = "";
					$userfio = "";
				}
			} else {
				$userid = "";
				$userfio = "";
			}
			
//            $command->insert($this->logTableName,array(
//                'level'=>$log[1],
//                'category'=>$log[2],
//                'logtime'=>$logTime,
//                'user_ip'=> Yii::app()->request->userHostAddress, //Get Ip 
//				'user_id'=> $userid,
//				'user_fio'=> $userfio,
//                'request_URL'=>Yii::app()->request->url, // Get Url
//                'message'=>$log[0]
//            ));
        }
    }
 
}
?>