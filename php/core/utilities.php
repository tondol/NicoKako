<?php

function array_at() {
	$numargs = func_num_args();
	$args = func_get_args();
	$arr = array_shift($args);
	foreach ($args as $arg) {
		$index = array_shift($args);
		$arr = $arr[$index];
	}
	return $arr;
}

function is_hankaku($str, $encoding='UTF-8') {
	mb_regex_encoding($encoding);
	if (!mb_ereg("^[!-~]*$", $str)) {
		return false;
	}
	return true;
}
function is_zenkaku($str, $encoding='UTF-8') {
	return !is_hankaku($str, $encoding);
}
function is_hiragana($str, $encoding='UTF-8') {
	mb_regex_encoding($encoding);
	$str = str_replace("　", "", $str);
	if (!mb_ereg("^[ぁ-ん]*$", $str)) {
		return false;
	}
	return true;
}
function is_katakana($str, $encoding='UTF-8') {
	mb_regex_encoding($encoding);
	$str = str_replace("　", "", $str);
	if (!mb_ereg("^[ァ-ヶー]*$", $str)) {
		return false;
	}
	return true;
}
function is_alpha_numeric($str, $encoding='UTF-8') {
	mb_regex_encoding($encoding);
	if (!mb_ereg("^[0-9A-Za-z]*$", $str)) {
		return false;
	}
	return true;
}
function is_alpha($str, $encoding='UTF-8') {
	mb_regex_encoding($encoding);
	if (!mb_ereg("^[A-Za-z]*$", $str)) {
		return false;
	}
	return true;
}
function is_digits($str, $encoding='UTF-8') {
	mb_regex_encoding($encoding);
	if (!mb_ereg("^[0-9]*$", $str)) {
		return false;
	}
	return true;
}
function is_telephone($str, $encoding='UTF-8') {
	mb_regex_encoding($encoding);
	if (!mb_ereg("^[0-9]{2,4}-[0-9]{2,4}-[0-9]{3,4}$", $str)) {
		return false;
	}
	return true;
}
function is_mail_address($str, $encoding='UTF-8') {
	mb_regex_encoding($encoding);
	if (!mb_ereg("^[\w\.\-\+]+@[\w\-]+(\.[\w\-]+)+$", $str)) {
		return false;
	}
	return true;
}

function h($value) {
	if (is_array($value)) {
		foreach ($value as $k => $v) {
			$value[$k] = htmlspecialchars($v, ENT_QUOTES, 'UTF-8');
		}
		return $value;
	} else {
		return htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
	}
}
function nl2br_h($value) {
	if (is_array($value)) {
		foreach ($value as $k => $v) {
			$value[$k] = nl2br(htmlspecialchars($v, ENT_QUOTES, 'UTF-8'));
		}
		return $value;
	} else {
		return nl2br(htmlspecialchars($value, ENT_QUOTES, 'UTF-8'));
	}
}

function guid($salt="") {
	return sha1($salt . uniqid(mt_rand(), true));
}
function mkpasswd($password, $salt="") {
	return sha1($salt . $password);
}

function current_date() {
	return date('Y-m-d H:i:s');
}
function current_date_iso() {
	return date('c');
}
