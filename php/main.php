#!/usr/bin/env php
<?php
class Node {
    public $x;
    public $y;
    public $left;
    public $right;

    public function __construct($x) {
        $this->x = $x;
        $this->y = rand();
        $this->left = null;
        $this->right = null;
    }
}

function merge($lower, $greater) {
    if ($lower === null) {
    	return $greater;
    }
    
    if ($greater === null) {
    	return $lower;
    }
    
    if ($lower->y < $greater->y) {
        $lower->right = merge($lower->right, $greater);
        return $lower;
    } else {
        $greater->left = merge($lower, $greater->left);
        return $greater;
    }
}

function splitBinary($orig, $value) {
    if ($orig === null) {
    	return [null, null];
    }
    
    if ($orig->x < $value) {
        $splitPair = splitBinary($orig->right, $value);
        $orig->right = $splitPair[0];
        return [$orig, $splitPair[1]];
    } else {
        $splitPair = splitBinary($orig->left, $value);
        $orig->left = $splitPair[1];
        return [$splitPair[0], $orig];
    }
}

function merge3($lower, $equal, $greater) {
    return merge(merge($lower, $equal), $greater);
}


class SplitResult {
    public $lower;
    public $equal;
    public $greater;

    public function __construct($lower, $equal, $greater) {
        $this->lower = $lower;
        $this->equal = $equal;
        $this->greater = $greater;
    }
}


function split($orig, $value) {
    [$lower, $equalGreater] = splitBinary($orig, $value);
    [$equal, $greater] = splitBinary($equalGreater, $value + 1);
    return new SplitResult($lower, $equal, $greater);
}


class Tree {
    public $root;

    public function __construct() {
        $this->root = null;
    }

    public function has_value($x) {
        $splited = split($this->root, $x);
        $res = $splited->equal !== null;
        $this->root = merge3($splited->lower, $splited->equal, $splited->greater);
        return $res;
    }
    
    public function insert($x) {
        $splited = split($this->root, $x);
        if ($splited->equal === null) {;
            $splited->equal = new Node($x);
        }
        $this->root = merge3($splited->lower, $splited->equal, $splited->greater);
    }

    public function erase($x) {
        $splited = split($this->root, $x);
        $this->root = merge($splited->lower, $splited->greater);
    }
}

function main() {
    $tree = new Tree();
    $cur = 5;
    $res = 0;

    for ($i = 1; $i < 1000000; ++$i) {
        $a = $i % 3;
        $cur = ($cur * 57 + 43) % 10007;
        if ($a === 0) {
            $tree->insert($cur);
        } else if ($a === 1) {
            $tree->erase($cur);
        } else if ($a == 2) {
            $res += $tree->has_value($cur) ? 1 : 0;
        }
    }
    echo $res;
}

main();
