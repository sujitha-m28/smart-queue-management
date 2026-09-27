package com.example.queuemanagement.controller;
import org.springframework.http.ResponseEntity;
import com.example.queuemanagement.dto.CustomerDTO;
import com.example.queuemanagement.entity.Customer;
import com.example.queuemanagement.service.CustomerService;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Optional;
import jakarta.validation.Valid;
@RestController
public class CustomerController {
    private final CustomerService customerService;

    public CustomerController(CustomerService customerService) {
        this.customerService = customerService;
    }

    @PostMapping("/customers")
    public ResponseEntity<Customer> createCustomer(@RequestBody @Valid CustomerDTO customerDTO) {
         Customer customer=customerService.createCustomer(customerDTO);
           return ResponseEntity.status(201).body(customer);
    }

    @GetMapping("/customers")
    public List<Customer> getCustomers(){
        return customerService.getCustomers();
    }

    @GetMapping("/customers/{id}")
    public ResponseEntity<Customer> getCustomerById(@PathVariable Long id) {
        Customer customer = customerService.getCustomerById(id);
        return ResponseEntity.ok(customer);
    }
    @DeleteMapping("/customers/{id}")
    public ResponseEntity<Void> deleteCustomer(@PathVariable Long id) {
        customerService.deleteCustomer(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/customers/{id}")
    public ResponseEntity<Customer> updateCustomer(
            @PathVariable Long id,
            @RequestBody @Valid CustomerDTO customerDTO) {

        Customer customer = customerService.updateCustomer(id, customerDTO);
        return ResponseEntity.ok(customer);
    }



}
