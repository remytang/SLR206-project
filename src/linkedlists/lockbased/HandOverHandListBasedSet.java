package linkedlists.lockbased;

import contention.abstractions.AbstractCompositionalIntSet;

public class HandOverHandListBasedSet extends AbstractCompositionalIntSet {

    private Node head;
    private Node tail;

    public HandOverHandListBasedSet(){     
	  head = new Node(Integer.MIN_VALUE);
	  tail = new Node(Integer.MAX_VALUE);
          head.next = tail;
    }
    
	@Override
	public boolean addInt(int item) {
		Node pred=head;
		Node curr=pred.next;
		try {
			pred.lock();
			curr.lock();
			try {
				while (curr.value < item) {
					pred.unlock();
					pred = curr;
					curr = pred.next;
					curr.lock();
				}
				if (curr.value==item) {
					return false;}
				Node node = new Node(item);
				node.next=curr;
				pred.next=node;
				return true;
			} finally {
				curr.unlock();
			}
		} finally {
			pred.unlock();
		}
	}

	@Override
	public boolean removeInt(int item) {
		Node pred=head;
		Node curr=pred.next;
		try {
			pred.lock();
			curr.lock();
			try {
				while (curr.value < item){
					pred.unlock();
					pred = curr;
					curr = pred.next;
					curr.lock();
				}
				if (curr.value==item){
					pred.next=curr.next;
					return true;}
				return false;
			} finally {
				curr.unlock();
			}
		} finally{
			pred.unlock();
		}
	}

	@Override
	public boolean containsInt(int item) {
		Node pred=head;
		Node curr=pred.next;
		try {
			pred.lock();
			curr.lock();
			try {
				while (curr.value < item) {
					pred.unlock();
					pred = curr;
					curr = pred.next;
					curr.lock();
				}
				return (curr.value==item);
			} finally {
				curr.unlock();
			} 
		} finally {
			pred.unlock();
		}
	}

	@Override
	public int size() {
        int count = 0;

        Node curr = head.next;
        while (curr.value != Integer.MAX_VALUE) {
            curr = curr.next;
            count++;
        }
        return count;
    }

	@Override
	public void clear() {
	      head = new Node(Integer.MIN_VALUE);
	      head.next = new Node(Integer.MAX_VALUE);
	}

}
