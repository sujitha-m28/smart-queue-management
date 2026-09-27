package com.example.queuemanagement.service;

import com.example.queuemanagement.dto.CustomerDTO;
import com.example.queuemanagement.entity.Customer;
import com.example.queuemanagement.repository.CustomerRepository;
import org.springframework.stereotype.Service;
import com.example.queuemanagement.exception.CustomerNotFoundException;
import java.util.List;


@Service
public class CustomerService {

   private final CustomerRepository customerRepository;
   CustomerService(CustomerRepository customerRepository){
       this.customerRepository=customerRepository;
   }

  public Customer createCustomer(CustomerDTO customerDTO){
       Customer customer=new Customer();
       customer.setName(customerDTO.getName());
       customer.setPhone(customerDTO.getPhone());
       return customerRepository.save(customer);

   }

   public List<Customer> getCustomers(){
       return customerRepository.findAll();
   }

   public Customer getCustomerById(Long id){
       return customerRepository.findById(id).orElseThrow(()->new CustomerNotFoundException("Customer with id "+id +"not found"));
   }

   public void deleteCustomer(Long id){
       Customer customer=customerRepository.findById(id).orElseThrow(()->new CustomerNotFoundException("Customer with id "+id+" not found"));
       customerRepository.deleteById(id);
   }

    public Customer updateCustomer(Long id, CustomerDTO customerDTO) {

        Customer existingCustomer = customerRepository.findById(id).orElseThrow(()->new CustomerNotFoundException("Customer with id "+id+" not found"));

        existingCustomer.setName(customerDTO.getName());
        existingCustomer.setPhone(customerDTO.getPhone());

        return customerRepository.save(existingCustomer);
    }


}

