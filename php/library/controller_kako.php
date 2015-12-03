<?php

class Controller_kako extends Controller {
        function get_title_helper($chain, $options) {
                foreach ($options as $k => $v) {
                        if ($k == $chain || (is_null($chain) && $k == $this->chain)) {
                                return $options[$k];
                        }
                }
                return parent::get_title($chain);
        }
        function get_url_helper($chain, $params, $options) {
                foreach ($options as $k => $v) {
                        if ($k == $chain || (is_null($chain) && $k == $this->chain)) {
                                $params = array_merge(
                                        $v,
                                        is_null($params) ? array() : $params
                                );
                        }
                }
                return parent::get_url($chain, $params);
        }
}
