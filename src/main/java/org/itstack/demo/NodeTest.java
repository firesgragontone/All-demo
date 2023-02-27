package org.itstack.demo;

import lombok.val;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/2/16
 */
public class NodeTest {
    static class Node{
        public int val;
        public Node next;
        public Node(int val){
            this.val = val;
        }
    }

    public static void main(String[] args) {
        Node head = new Node(0);
        Node tmp = head;
        for (int i = 1; i < 5; i++) {
            tmp.next = new Node(i);
            tmp = tmp.next;
        }
        Node tmp2 = head;
        Node newHead = new Node(head.val);
        Node tn = null;
        while (tmp2.next != null){
            tn = newHead;
            newHead = new Node(tmp2.next.val);
            newHead.next = tn;
            tmp2 = tmp2.next;
        }
        head.next = null;
        while (newHead != null){
            System.out.println(newHead.val);
            newHead = newHead.next;
        }

    }
}
