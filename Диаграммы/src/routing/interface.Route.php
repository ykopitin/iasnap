<?php

error_reporting(E_ALL);

/**
 * Система обработки заявлений - routing\interface.Route.php
 *
 * $Id$
 *
 * This file is part of Система обработки заявлений.
 *
 * Automatically generated on 31.07.2014, 23:22:52 with ArgoUML PHP module 
 * (last revised $Date: 2010-01-12 20:14:42 +0100 (Tue, 12 Jan 2010) $)
 *
 * @author firstname and lastname of author, <author@example.org>
 * @package routing
 */

if (0 > version_compare(PHP_VERSION, '5')) {
    die('This file was generated for PHP 5');
}

/* user defined includes */
// section -87--2-46--125-71076673:1478d96e126:-8000:0000000000000C77-includes begin
// section -87--2-46--125-71076673:1478d96e126:-8000:0000000000000C77-includes end

/* user defined constants */
// section -87--2-46--125-71076673:1478d96e126:-8000:0000000000000C77-constants begin
// section -87--2-46--125-71076673:1478d96e126:-8000:0000000000000C77-constants end

/**
 * Short description of class routing_Route
 *
 * @access public
 * @author firstname and lastname of author, <author@example.org>
 * @package routing
 */
interface routing_Route
{


    // --- OPERATIONS ---

    /**
     * Short description of method getNodes
     *
     * @access public
     * @author firstname and lastname of author, <author@example.org>
     * @param  Integer index
     * @return routing_Node
     */
    public function getNodes( Integer $index);

} /* end of interface routing_Route */

?>